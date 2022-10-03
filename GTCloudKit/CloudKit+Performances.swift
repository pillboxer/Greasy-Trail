import GTCoreData
import CloudKit
import Model
import ComposableArchitecture
import Core

func fetchPerformances(
    _ date: Date?,
    newValues: Bool,
    environment: CloudKitEnvironment) -> Effect<CloudKitAction, Never> {
        .run(operation: { send in
            for try await event in environment.client.fetchPerformances(date) {
                switch event {
                case .updateFetchProgress(let type, let progress):
                    await send(.cloudKitClient(.success(.updateFetchProgress(
                        of: type, to: progress))), animation: .default)
                case .completeFetch(let newPerformances):
                    let newValues = newPerformances ? newPerformances : newValues
                    await send(.cloudKitClient(.success(.completeFetch(newValues: newValues))), animation: .default)
                default:
                    fatalError("Received unknown event whilst fetching performances")
                }
            }
        }, catch: { error, send in
            logger.log(
                level: .error,
                "Received failure whilst fetching performances: \(String(describing: error), privacy: .public)")
            await send(.cloudKitClient(.failure(error)))
        })
    }

func uploadPerformance(
    with model: PerformanceUploadModel,
    environment: CloudKitEnvironment) -> Effect<CloudKitAction, Never> {
        .run(operation: { send in
            for try await event in environment.client.uploadPerformance(model) {
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
                "Received failure whilst uploading performance: \(String(describing: error), privacy: .public)")
            await send(.cloudKitClient(.failure(error)))
        })
    }

extension CloudKitClient {
    
    static func fetchPerformancesLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateFetchProgress(of: .performance, to: 0))
                    let records = try await fetchRecords(of: .performance, after: date)
                    let venues = records.compactMap { $0.string(for: .venue) }
                    let dates = records.compactMap { $0.double(for: .date)?.rounded() }
                    let dateFormats = records.map { $0.string(for: .dateFormat) }
                    let lbNumbers = records.map { $0.ints(for: .lbNumbers) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateFetchProgress(
                            of: .performance,
                            to: Double(index) / Double(records.count)))
                        let venue = venues[index]
                        let date = dates[index]
                        let lbs = lbNumbers[index]
                        let dateFormat = dateFormats[index]
                        let ordered = try await getOrderedSongRecords(from: record)
                        let songIDs = ordered.compactMap { $0.recordID.recordName }
                        let correspondingSongs: [Song] = songIDs.compactMap { id in
                            let predicate = NSPredicate(format: "uuid == %@", id)
                            return context.fetchAndWait(Song.self, with: predicate).first
                        }
                        await context.perform {
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let existingPerformance = context.fetchAndWait(Performance.self, with: predicate).first
                            let performance = existingPerformance ?? Performance(context: context)
                            performance.venue = venue
                            performance.date = date
                            performance.lbNumbers = lbs
                            performance.dateFormatString = dateFormat
                            performance.uuid = record.recordID.recordName
                            let orderedSet = NSOrderedSet(array: correspondingSongs)
                            performance.songs = orderedSet
                        }
                        await context.asyncSave()
                    }
                    continuation.yield(.updateFetchProgress(of: .performance, to: 1))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    static func uploadPerformanceLive(from model: PerformanceUploadModel) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            continuation.yield(.updateUploadProgress(to: 0))
            let record = CKRecord(recordType: DylanRecordType.performance.rawValue,
                                  recordID: CKRecord.ID(recordName: model.recordName))
            var refs: [CKRecord.Reference] = []
            
            for uuid in model.uuids {
                let reference = CKRecord.Reference(recordID: .init(recordName: uuid),
                                                   action: .none)
                refs.append(reference)
            }
            record[DylanRecordField.songs.rawValue] = refs
            record[DylanRecordField.venue.rawValue] = model.venue
            record[DylanRecordField.date.rawValue] = model.date
            record[DylanRecordField.lbNumbers.rawValue] = model.lbs
            record[DylanRecordField.dateFormat.rawValue] = model.dateFormat.rawValue
            
            uploadRecords([record], with: continuation)
        }
    }
}
