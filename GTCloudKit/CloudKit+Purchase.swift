import Model
import ComposableArchitecture
import CloudKit
import Core

func uploadPurchase(
    with model: PurchaseUploadModel,
    environment: CloudKitEnvironment)
-> Effect<CloudKitAction, Never> {
    .run(operation: { send in
        for try await event in environment.client.uploadPurchase(model) {
            switch event {
            case .updateUploadProgress(let progress):
                await send(.cloudKitClient(.success(.updateUploadProgress(to: progress))))
            case .completeUpload:
                await send(.cloudKitClient(.success(.completeUpload)))
            default: fatalError()
            }
        }
    }, catch: { error, send in
        logger.log(
            level: .error,
            "Received failure whilst uploading purchase: \(String(describing: error), privacy: .public)")
        await send(.cloudKitClient(.failure(error)))
    })
}

func fetchPurchases(environment: CloudKitEnvironment) -> Effect<CloudKitAction, Never> {
    .run(operation: { send in
        for try await event in environment.client.fetchPurchases() {
            switch event {
            case .updateAmountDonated(let amount):
                await send(.cloudKitClient(.success(.updateAmountDonated(amount))))
            default:
                fatalError("Received unknown event whilst fetching purchases")
            }
        }
    }, catch: { error, send in
        let errorString = String(describing: error)
        logger.log(level: .error, "Received failure whilst fetching purchases: \(errorString, privacy: .public)")
        if let error = error as? CKError {
            await send(.cloudKitClient(.failure(error)))
        }
    })
}

extension CloudKitClient {
    
    static func uploadPurchaseLive(from model: PurchaseUploadModel) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            continuation.yield(.updateUploadProgress(to: 0))
            let record = CKRecord(recordType: DylanRecordType.purchase.rawValue)
            record[DylanRecordField.type.rawValue] = model.type.rawValue
            record[DylanRecordField.amount.rawValue] = model.amount
            uploadRecords([record], to: PrivateDatabase, with: continuation)
        }
    }
    
    static func fetchPurchasesLive() -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    let records = try await fetchRecords(of: .purchase, database: PrivateDatabase)
                    let donations = records.filter { $0.int(for: .type) == PurchaseType.donation.rawValue }
                    let amounts = donations.compactMap { $0.double(for: .amount) }
                    let total = amounts.reduce(0, +)
                    continuation.yield(.updateAmountDonated(total))
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
