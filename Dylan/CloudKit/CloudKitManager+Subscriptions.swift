//
//  CloudKitManager+Subscriptions.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import CloudKit
import OSLog

extension CloudKitManager {
    
    func subscribeToDatabase() {
        
        let notification = CKSubscription.NotificationInfo()
        notification.shouldSendContentAvailable = true

        let songSubscriptionID = NSLocalizedString("cloud_kit_subscription_songs", comment: "")
        let songSubscription = CKQuerySubscription(recordType: DylanRecordType.song.rawValue, predicate: NSPredicate(value: true), subscriptionID: songSubscriptionID, options: [.firesOnRecordDeletion])
        songSubscription.notificationInfo = notification

        let albumSubscriptionID = NSLocalizedString("cloud_kit_subscription_albums", comment: "")
        let albumSubscription = CKQuerySubscription(recordType: DylanRecordType.album.rawValue, predicate: NSPredicate(value: true), subscriptionID: albumSubscriptionID, options: [.firesOnRecordDeletion])
        albumSubscription.notificationInfo = notification
        
        let performanceSubscriptionID = NSLocalizedString("cloud_kit_subscription_performances", comment: "")
        let performanceSubscription = CKQuerySubscription(recordType: DylanRecordType.performance.rawValue, predicate: NSPredicate(value: true), subscriptionID: performanceSubscriptionID, options: [.firesOnRecordDeletion])
        performanceSubscription.notificationInfo = notification
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [songSubscription, albumSubscription, performanceSubscription])

        operation.modifySubscriptionsResultBlock = { result in
            switch result {
            case .failure(let error):
                os_log("Failed to add subscriptions: %@", log: Log_CloudKit, String(describing: error))
            case .success():
                os_log("Added subscriptions successfully")
            }
        }
        
        database.add(operation)
                                                           
    }
    
}
