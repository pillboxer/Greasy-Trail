import GTCoreData
import Model
import CloudKit
import Core
import ComposableArchitecture

public struct CloudKitEnvironment {
    var client: CloudKitClient
    
    public init(client: CloudKitClient) {
        self.client = client
    }
}

public struct CloudKitClient {
    var fetchSongs: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var fetchAlbums: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var fetchPerformances: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var uploadPerformance: @Sendable (_ model: PerformanceUploadModel) -> AsyncThrowingStream<Event, Error>
    var subscribeToDatabases: @Sendable () -> Void
    
    public enum Event: Equatable {
        case updateFetchProgress(of: DylanRecordType, to: Double)
        case updateUploadProgress(to: Double)
        case completeFetch(newValues: Bool)
        case completeUpload
    }
}

extension CloudKitClient {
    
    public static let live = CloudKitClient(
        fetchSongs: { date in
            fetchSongsLive(after: date)
        }, fetchAlbums: { date in
            fetchAlbumsLive(after: date)
        }, fetchPerformances: { date in
            fetchPerformancesLive(after: date)
        }, uploadPerformance: { model in
            uploadPerformanceLive(from: model)
        }, subscribeToDatabases: {
            subscribeToDatabasesLive()
        }
    )
    
    private static func fetchSongsLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateFetchProgress(of: .song, to: 0))
                    let records = try await fetchRecords(of: .song, after: date)
                    let titles = records.map { $0.string(for: .title) }
                    let authors = records.map { $0.string(for: .author) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateFetchProgress(of: .song, to: Double(index) / Double(records.count)))
                        await context.perform {
                            let title = titles[index] ?? "Unknown Title"
                            let author = authors[index]
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let song: Song
                            if let existingSong = context.fetchAndWait(Song.self, with: predicate).first {
                                song = existingSong
                            } else {
                                song = Song(context: context)
                            }
                            song.title = title
                            song.author = author
                            song.uuid = record.recordID.recordName
                        }
                        await context.asyncSave()
                    }
                    continuation.yield(.updateFetchProgress(of: .song, to: 1))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private static func fetchPerformancesLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateFetchProgress(of: .performance, to: 0))
                    let records = try await fetchRecords(of: .performance, after: date)
                    let venues = records.compactMap { $0.string(for: .venue) }
                    let dates = records.compactMap { $0.double(for: .date) }
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
    
    private static func fetchAlbumsLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateFetchProgress(of: .album, to: 0))
                    let records = try await fetchRecords(of: .album, after: date)
                    let titles = records.compactMap { $0.string(for: .title) }
                    let releaseDates = records.map { $0.double(for: .releaseDate) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateFetchProgress(of: .album, to: Double(index) / Double(records.count)))
                        let title = titles[index]
                        let releaseDate = releaseDates[index]
                        let ordered = try await getOrderedSongRecords(from: record)
                        let songIDs = ordered.compactMap { $0.recordID.recordName }
                        let correspondingSongs: [Song] = songIDs.compactMap { id in
                            let predicate = NSPredicate(format: "uuid == %@", id)
                            return context.fetchAndWait(Song.self, with: predicate).first
                        }
                        await context.perform {
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let existingAlbum = context.fetchAndWait(Album.self, with: predicate).first
                            let album = existingAlbum ?? Album(context: context)
                            album.title = title
                            album.releaseDate = releaseDate ?? -1
                            album.uuid = record.recordID.recordName
                            let orderedSet = NSOrderedSet(array: correspondingSongs)
                            album.songs = orderedSet
                        }
                        await context.asyncSave()
                    }
                    continuation.yield(.updateFetchProgress(of: .album, to: 1))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private static func uploadPerformanceLive(from model: PerformanceUploadModel) -> AsyncThrowingStream<Event, Error> {
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
            
            record["songs"] = refs
            record["venue"] = model.venue
            record["date"] = model.date
            record["LBNumbers"] = model.lbs
            record["dateFormat"] = model.dateFormat.rawValue
            
            let operation = CKModifyRecordsOperation(recordsToSave: [record])
            operation.qualityOfService = .userInitiated
            DylanDatabase.add(operation)
            
            operation.perRecordProgressBlock = { _, progress in
                continuation.yield(.updateUploadProgress(to: progress))
            }
            
            operation.savePolicy = .changedKeys
            
            operation.modifyRecordsResultBlock = { result in
                switch result {
                case .failure(let error):
                    continuation.finish(throwing: error)
                default:
                    continuation.yield(.completeUpload)
                    continuation.finish()
                }
            }
            
            operation.perRecordSaveBlock = { _, result in
                switch result {
                case .failure(let error):
                    continuation.finish(throwing: error)
                default:
                    return
                }
            }
        }
    }
    
    private static func subscribeToDatabasesLive() {
        
            let notification = CKSubscription.NotificationInfo()
            notification.shouldSendContentAvailable = true
            
            let songSubscriptionID = NSLocalizedString("cloud_kit_subscription_songs", comment: "")
            let songSubscription = CKQuerySubscription(recordType: DylanRecordType.song.rawValue,
                                                       predicate: NSPredicate(value: true),
                                                       subscriptionID: songSubscriptionID,
                                                       options: [.firesOnRecordDeletion])
            songSubscription.notificationInfo = notification
            
            let albumSubscriptionID = NSLocalizedString("cloud_kit_subscription_albums", comment: "")
            let albumSubscription = CKQuerySubscription(recordType:
                                                            DylanRecordType.album.rawValue,
                                                        predicate: NSPredicate(value: true),
                                                        subscriptionID: albumSubscriptionID,
                                                        options: [.firesOnRecordDeletion])
            albumSubscription.notificationInfo = notification
            
            let performanceSubscriptionID = NSLocalizedString("cloud_kit_subscription_performances", comment: "")
            let performanceSubscription = CKQuerySubscription(recordType: DylanRecordType.performance.rawValue,
                                                              predicate: NSPredicate(value: true),
                                                              subscriptionID: performanceSubscriptionID,
                                                              options: [.firesOnRecordDeletion])
            performanceSubscription.notificationInfo = notification
            let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [songSubscription,
                                                                                 albumSubscription,
                                                                                 performanceSubscription])
            
            operation.modifySubscriptionsResultBlock = { result in
                switch result {
                case .failure(let error):
                    logger.log(level: .error, "Could not subscribe to database. Error \(String(describing: error), privacy: .public)")
                case .success:
                    logger.log("Successfully subscribed to database")
                }
            }
            DylanDatabase.add(operation)
        }
}
