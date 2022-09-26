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
    var uploadAlbum: @Sendable (_ model: AlbumUploadModel) -> AsyncThrowingStream<Event, Error>
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
        }, uploadAlbum: { model in
            uploadAlbumLive(from: model)
        }, subscribeToDatabases: {
            subscribeToDatabasesLive()
        }
    )
    
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
                logger.log(
                    level: .error,
                    "Could not subscribe to database. Error \(String(describing: error), privacy: .public)")
            case .success:
                logger.log("Successfully subscribed to database")
            }
        }
        DylanDatabase.add(operation)
    }
}
