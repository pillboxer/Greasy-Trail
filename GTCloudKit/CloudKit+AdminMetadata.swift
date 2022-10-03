import ComposableArchitecture
import CloudKit

func fetchAdminMetadata(environment: CloudKitEnvironment) -> Effect<CloudKitAction, Never> {
    .run(operation: { send in
        for try await event in environment.client.fetchAdminMetadata() {
            switch event {
            case .adminCheckPassed:
                await send(.cloudKitClient(.success(.adminCheckPassed)))
            default:
                fatalError("Received unknown event whilst fetching songs")
            }
        }
    }, catch: { error, send in
        let errorString = String(describing: error)
        logger.log(level: .error, "Received failure whilst checking admin status: \(errorString, privacy: .public)")
        if let error = error as? CKError {
            await send(.cloudKitClient(.failure(error)))
        }
    })
}

extension CloudKitClient {
    
    static func fetchAdminMetadataLive() -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    _ = try await fetchRecords(of: .adminMetadata)
                    continuation.yield(.adminCheckPassed)
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
}
