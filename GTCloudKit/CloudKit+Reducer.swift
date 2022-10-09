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
    
    // Fetch
    case .fetchAdminMetadata:
        return fetchAdminMetadata(environment: environment)
    case .fetchPurchases:
        return fetchPurchases(environment: environment)
    case .start(let date):
        if let mode = state.mode, !mode.canStartNewOperation {
            logger.log("Attempted to start but not able to fetch. Give up")
            return .none
        }
        logger.log("Starting fetch of all records")
        return .run { send in
            await send(.fetchPurchases)
            await send(.fetchSongs(date))
        }
    case .fetchSongs(let date):
        return fetchSongs(date, environment: environment)
    case .fetchAlbums(let date, let newValues):
        return fetchAlbums(date, newValues: newValues, environment: environment)
    case .fetchPerformances(let date, let newValues):
        return fetchPerformances(date, newValues: newValues, environment: environment)
        
    // Upload
    case .uploadPurchase(let product, let type):
        let amount = round(product.price.doubleValue * 100) / 100.0
        let model = PurchaseUploadModel(type: type, amount: amount)
        return uploadPurchase(with: model, environment: environment)
    case .uploadAlbum(let model):
        let titles = model.songs.map { $0.title }
        let uuids = titles.compactMap { Detective().uuid(for: $0) }
        guard uuids.count == titles.count else { fatalError("One or more songs could not be found to upload") }
        let uploadModel = AlbumUploadModel(recordName: model.uuid,
                                           title: model.title,
                                           releaseDate: model.releaseDate,
                                           uuids: uuids)
        return uploadAlbum(with: uploadModel, environment: environment)
    case .uploadPerformance(let model):
        let titles = model.songs.map { $0.title }
        let uuids = titles.compactMap { Detective().uuid(for: $0) }
        guard uuids.count == titles.count else { fatalError("One or more songs could not be found to upload") }
        let uploadModel = PerformanceUploadModel(recordName: model.uuid,
                                                 venue: model.venue,
                                                 date: model.date,
                                                 lbs: model.lbNumbers,
                                                 uuids: uuids,
                                                 dateFormat: model.dateFormat)
        return uploadPerformance(with: uploadModel, environment: environment)
    case.uploadSong(let model):
        let uuid = Detective().uuid(for: model.baseSongUUID ?? "" )
        if let base = model.baseSongUUID, !base.isEmpty, uuid == nil {
            state.mode = .operationFailed(GTError(UploadError.invalidBaseSongUUID(base)))
            return .none
        }
        let uploadModel = SongUploadModel(recordName: model.uuid,
                                          title: model.title,
                                          author: model.author,
                                          baseSongUUID: uuid)
        return uploadSong(with: uploadModel, environment: environment)
    case .subscribeToDatabases:
        return .fireAndForget { environment.client.subscribeToDatabases() }
        
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
    case .cloudKitClient(.success(.updateAmountDonated(let amount))):
        state.amountDonated = amount
        return .none
    }
}
