//
//  AppDelegate.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Cocoa
import CoreData
import OSLog
import GTCoreData
import GTLogging
import GTCloudKit

class AppDelegate: NSObject, NSApplicationDelegate {

    let cloudKitManager = CloudKitManager(DylanDatabase)

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.registerForRemoteNotifications()
        deleteMarkedDeletables()

        let isRunningTests = TestHelper.isRunningTests
        os_log("Test suite is being run: %{BOOL}d", log: Log_AppDelegate, isRunningTests)
        if !isRunningTests {
            _ = PersistenceController.shared
            Task {
                await cloudKitManager.start()
            }
        }
    }

    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
        guard let ckDict = userInfo["ck"] as? [String: Any],
              let qryDict = ckDict["qry"] as? [String: Any],
              let toDelete = qryDict["rid"] as? String,
              let type = qryDict["sid"] as? String else {
            return
        }

        let songSubscriptionID = NSLocalizedString("cloud_kit_subscription_songs", comment: "")
        let albumSubscriptionID = NSLocalizedString("cloud_kit_subscription_albums", comment: "")
        let performanceSubscriptionID = NSLocalizedString("cloud_kit_subscription_performances", comment: "")

        let context = PersistenceController.shared.newBackgroundContext()
        context.perform {
            let object: Deletable?
            let predicate = NSPredicate(format: "uuid == %@", toDelete)
            switch type {
            case songSubscriptionID:
                object = context.fetchAndWait(Song.self, with: predicate).first
            case albumSubscriptionID:
                object = context.fetchAndWait(Album.self, with: predicate).first
            case performanceSubscriptionID:
                object = context.fetchAndWait(Performance.self, with: predicate).first
            default:
                return
            }

            guard let object = object else {
                os_log("No object to delete. Give up", log: Log_CoreData)
                return
            }

            object.markedAsDeleted = true

            os_log("Deleting object with id %{public}@", log: Log_CoreData, toDelete)
            context.delete(object)
            context.performSave()
        }
    }

    func deleteMarkedDeletables() {
        var deleteables: [Deletable] = []
        let context = PersistenceController.shared.newBackgroundContext()
        let predicate = NSPredicate(format: "markedAsDeleted == true")
        let markedSongs = context.fetchAndWait(Song.self, with: predicate) as [Deletable]
        let markedAlbums = context.fetchAndWait(Album.self, with: predicate) as [Deletable]
        let markedPerformances = context.fetchAndWait(Performance.self, with: predicate) as [Deletable]
        deleteables.append(contentsOf: markedSongs + markedAlbums + markedPerformances)
        os_log("%{public}@ objects ready for delete", log: Log_CoreData, String(describing: deleteables.count))
        deleteables.forEach { context.delete($0) }

    }
}
