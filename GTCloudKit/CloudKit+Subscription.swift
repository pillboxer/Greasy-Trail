import Core
import CloudKit

extension CloudKitClient {
    
    static func subscribeToDatabasesLive() {
        
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
