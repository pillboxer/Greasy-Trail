import GTCoreData
import Model
import CloudKit

public struct CloudKitEnvironment {
    var client: CloudKitClient
    
    public init(client: CloudKitClient) {
        self.client = client
    }
}

public struct GTError: Error, Equatable {
    public let error: NSError
    
    public init(_ error: Error) {
        self.error = error as NSError
    }
}

public struct CloudKitClient {
    var fetchSongs: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var fetchAlbums: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var fetchPerformances: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var uploadPerformance: @Sendable (_ model: PerformanceUploadModel) -> AsyncThrowingStream<Event, Error>
    
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
                            let predicate = NSPredicate(format: "title == %@", title)
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
                    let lbNumbers = records.map { $0.ints(for: .lbNumbers) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateFetchProgress(
                            of: .performance,
                            to: Double(index) / Double(records.count)))
                        let venue = venues[index]
                        let date = dates[index]
                        let lbs = lbNumbers[index]
                        let ordered = try await getOrderedSongRecords(from: record)
                        let songTitles = ordered.compactMap { $0.string(for: .title) }
                        let correspondingSongs: [Song] = songTitles.compactMap { title in
                            let predicate = NSPredicate(format: "title == %@", title)
                            return context.fetchAndWait(Song.self, with: predicate).first
                        }
                        await context.perform {
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let existingPerformance = context.fetchAndWait(Performance.self, with: predicate).first
                            let performance = existingPerformance ?? Performance(context: context)
                            performance.venue = venue
                            performance.date = date
                            performance.lbNumbers = lbs
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
                        let songTitles = ordered.compactMap { $0.string(for: .title) }
                        let correspondingSongs: [Song] = songTitles.compactMap { title in
                            let predicate = NSPredicate(format: "title == %@", title)
                            return context.fetchAndWait(Song.self, with: predicate).first
                        }
                        await context.perform {
                            let predicate = NSPredicate(format: "title == %@", title)
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
}

public enum Mode: Equatable {
    case downloaded
    case downloading(progress: Double, DylanRecordType)
    case operationFailed(GTError)
    
    case uploading(progress: Double)
    case uploaded
    case uploadFailed(GTError)
}
