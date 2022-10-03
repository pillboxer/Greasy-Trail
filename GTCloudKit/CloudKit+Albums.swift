import ComposableArchitecture
import Model
import CloudKit
import GTCoreData
import Core

func fetchAlbums(_ date: Date?,
                 newValues: Bool,
                 environment: CloudKitEnvironment) -> Effect<CloudKitAction, Never> {
     .run(operation: { send in
        for try await event in environment.client.fetchAlbums(date) {
            switch event {
            case .updateFetchProgress(let type, let progress):
                await send(.cloudKitClient(.success(.updateFetchProgress(
                    of: type, to: progress))), animation: .default)
            case .completeFetch(let newAlbums):
                let newValues = newAlbums ? newAlbums : newValues
                await send(.fetchPerformances(date, newValues), animation: .default)
            default:
                fatalError("Received unknown event whilst fetching albums")
            }
        }
    }, catch: { error, send in
        logger.log(
            level: .error,
            "Received failure whilst fetching albums: \(String(describing: error), privacy: .public)")
        await send(.cloudKitClient(.failure(error)))
    })
}

func uploadAlbum(with model: AlbumUploadModel, environment: CloudKitEnvironment) -> Effect<CloudKitAction, Never> {
    return .run(operation: { send in
        for try await event in environment.client.uploadAlbum(model) {
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
            "Received failure whilst uploading album: \(String(describing: error), privacy: .public)")
        await send(.cloudKitClient(.failure(error)))
    })

}

extension CloudKitClient {
    
    static func fetchAlbumsLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
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
    
    static func uploadAlbumLive(from model: AlbumUploadModel) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            continuation.yield(.updateUploadProgress(to: 0))
            let record = CKRecord(recordType: DylanRecordType.album.rawValue,
                                  recordID: CKRecord.ID(recordName: model.recordName))
            var refs: [CKRecord.Reference] = []
            
            for uuid in model.uuids {
                let reference = CKRecord.Reference(recordID: .init(recordName: uuid),
                                                   action: .none)
                refs.append(reference)
            }
            record[DylanRecordField.songs.rawValue] = refs
            record[DylanRecordField.title.rawValue] = model.title
            record[DylanRecordField.releaseDate.rawValue] = model.releaseDate
            uploadRecords([record], with: continuation)
        }
    }
}
