import ComposableArchitecture
import Model
import Detective
import CloudKit
import GTCoreData
import Core

func fetchSongs(_ date: Date?, environment: CloudKitEnvironment) -> Effect<CloudKitAction, Never> {
    return .run(operation: { send in
        for try await event in environment.client.fetchSongs(date) {
            switch event {
            case .updateFetchProgress(let type, let progress):
                await send(.cloudKitClient(.success(.updateFetchProgress(
                    of: type, to: progress))), animation: .default)
            case .completeFetch(let newValues):
                await send(.fetchAlbums(date, newValues), animation: .default)
            default:
                fatalError("Received unknown event whilst fetching songs")
            }
        }
    }, catch: { error, send in
        let errorString = String(describing: error)
        logger.log(level: .error, "Received failure whilst fetching songs: \(errorString, privacy: .public)")
        await send(.cloudKitClient(.failure(error)))
    })
}

func uploadSong(with model: SongUploadModel, environment: CloudKitEnvironment) -> Effect<CloudKitAction, Never> {
    return .run(operation: { send in
        for try await event in environment.client.uploadSong(model) {
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
            "Received failure whilst uploading song: \(String(describing: error), privacy: .public)")
        await send(.cloudKitClient(.failure(error)))
    })
}

extension CloudKitClient {
    
    static func fetchSongsLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateFetchProgress(of: .song, to: 0))
                    let records = try await fetchRecords(of: .song, after: date)
                    let titles = records.map { $0.string(for: .title) }
                    let authors = records.map { $0.string(for: .author) }
                    let baseSongUUIDs = records.map { $0.string(for: .baseSongUUID) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateFetchProgress(of: .song, to: Double(index) / Double(records.count)))
                        await context.perform {
                            let title = titles[index] ?? "Unknown Title"
                            let author = (authors[index]?.isEmpty ?? true) ? nil : authors[index]
                            let baseSongUUID = baseSongUUIDs[index]
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let song: Song
                            if let existingSong = context.fetchAndWait(Song.self, with: predicate).first {
                                song = existingSong
                            } else {
                                song = Song(context: context)
                            }
                            song.baseSongUUID = baseSongUUID
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
    
    static func uploadSongLive(from model: SongUploadModel) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            continuation.yield(.updateUploadProgress(to: 0))
            let record = CKRecord(recordType: DylanRecordType.song.rawValue,
                                  recordID: CKRecord.ID(recordName: model.recordName))
            record[DylanRecordField.title.rawValue] = model.title
            record[DylanRecordField.author.rawValue] = model.author
            record[DylanRecordField.baseSongUUID.rawValue] = model.baseSongUUID
            uploadRecords([record], with: continuation)
        }
    }
}
