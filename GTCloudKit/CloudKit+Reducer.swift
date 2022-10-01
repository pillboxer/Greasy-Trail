import ComposableArchitecture
import Detective
import Model
import Core
import os
import CloudKit

private struct TimerID: Hashable {}

private enum UploadError: Error, CustomStringConvertible {
    case invalidBaseSongUUID(String)
    
    var description: String {
        switch self {
        case .invalidBaseSongUUID(let string):
            return tr("invalid_base_uuid_error", string)
        }
    }
}

public let cloudKitReducer = Reducer<CloudKitState, CloudKitAction, CloudKitEnvironment> { state, action, environment in
    switch action {
    case .fetchAdminMetadata:
        return .run(operation: { send in
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
            if let error = error as? CKError, error.code == .permissionFailure {
                print("permission error")
            } else {
                await send(.cloudKitClient(.failure(error)))
            }
        })
      
    case .start(let date):
        if let mode = state.mode, !mode.canFetch {
            logger.log("Attempted to start but not able to fetch. Give up")
            return .none
        }
        logger.log("Starting fetch of all records")
        return .run { send in await send(.fetchSongs(date)) }
    case .fetchSongs(let date):
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
    case .fetchAlbums(let date, let newValues):
        return .run(operation: { send in
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
    case .fetchPerformances(let date, let newValues):
        return .run(operation: { send in
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
    case .uploadAlbum(let model):
        let detective = Detective()
        let titles = model.songs.map { $0.title }
        let uuids = titles.compactMap { detective.uuid(for: $0) }
        guard uuids.count == titles.count else { fatalError("One or more songs could not be found to upload") }
        let uploadModel = AlbumUploadModel(recordName: model.uuid,
                                           title: model.title,
                                           releaseDate: model.releaseDate,
                                           uuids: uuids)
        return .run(operation: { send in
            for try await event in environment.client.uploadAlbum(uploadModel) {
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
    case .uploadPerformance(let model):
        let detective = Detective()
        let titles = model.songs.map { $0.title }
        let uuids = titles.compactMap { detective.uuid(for: $0) }
        guard uuids.count == titles.count else { fatalError("One or more songs could not be found to upload") }
        let uploadModel = PerformanceUploadModel(recordName: model.uuid,
                                                 venue: model.venue,
                                                 date: model.date,
                                                 lbs: model.lbNumbers,
                                                 uuids: uuids,
                                                 dateFormat: model.dateFormat)
        return .run(operation: { send in
            for try await event in environment.client.uploadPerformance(uploadModel) {
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
    case.uploadSong(let model):
        let detective = Detective()
        let uuid = detective.uuid(for: model.baseSongUUID ?? "" )
        if let base = model.baseSongUUID, !base.isEmpty, uuid == nil {
            state.mode = .operationFailed(GTError(UploadError.invalidBaseSongUUID(base)))
            return .none
        }
        let uploadModel = SongUploadModel(recordName: model.uuid,
                                          title: model.title,
                                          author: model.author,
                                          baseSongUUID: uuid)
        return .run(operation: { send in
            for try await event in environment.client.uploadSong(uploadModel) {
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
    case .subscribeToDatabases:
        return .fireAndForget {
            environment.client.subscribeToDatabases()
        }
        
        // Client
    case .cloudKitClient(.success(.updateUploadProgress(let progress))):
        state.mode = .uploading(progress: progress)
        return .none
    case .cloudKitClient(.success(.updateFetchProgress(let type, let progress))):
        state.mode = .downloading(progress: progress, type)
        return .none
    case .cloudKitClient(.success(.completeFetch(let newValues))):
        logger.log("Successfully fetched all records")
        state.mode = .downloaded
        state.lastFetchDate = newValues ? Date() : state.lastFetchDate
        return Effect(value: .completeDownload)
            .delay(for: 3, scheduler: DispatchQueue.main)
            .eraseToEffect()
    case .cloudKitClient(.success(.completeUpload)):
        state.mode = .uploaded
        return Effect(value: .start(date: .now.addingTimeInterval(-3600)))
            .delay(for: 3, scheduler: DispatchQueue.main)
            .eraseToEffect()
    case .cloudKitClient(.failure(let error)):
        state.mode = .operationFailed(.init(error))
        return .none
        // Completion
    case .completeDownload:
        state.mode = nil
        return .none
    case .cloudKitClient(.success(.adminCheckPassed)):
        state.displaysAdminFunctionality = true
        return .none
    }
}
