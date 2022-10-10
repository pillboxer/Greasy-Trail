import AppKit
import GTCoreData
import Core
import os

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    let logger = Logger(subsystem: .subsystem, category: "App Delegate")
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.registerForRemoteNotifications()
        deleteMarkedDeletables()
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
        guard let ckDict = userInfo["ck"] as? [String: Any],
              let qryDict = ckDict["qry"] as? [String: Any],
              let toDelete = qryDict["rid"] as? String,
              let type = qryDict["sid"] as? String else {
            return
        }

        let songSubscriptionID = tr("cloud_kit_subscription_songs")
        let albumSubscriptionID = tr("cloud_kit_subscription_albums")
        let performanceSubscriptionID = tr("cloud_kit_subscription_performances")

        let context = PersistenceController.shared.newBackgroundContext()
        context.perform { [self] in
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
                logger.log("Could not find object with uuid \(toDelete, privacy: .public)")
                return
            }

            object.markedAsDeleted = true
            logger.log("Deleting object with id \(toDelete, privacy: .public)")
            context.delete(object)
            context.performSave()
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
          return true
      }
    
    func deleteMarkedDeletables() {
        var deleteables: [Deletable] = []
        let context = PersistenceController.shared.newBackgroundContext()
        let predicate = NSPredicate(format: "markedAsDeleted == true")
        let markedSongs = context.fetchAndWait(Song.self, with: predicate) as [Deletable]
        let markedAlbums = context.fetchAndWait(Album.self, with: predicate) as [Deletable]
        let markedPerformances = context.fetchAndWait(Performance.self, with: predicate) as [Deletable]
        deleteables.append(contentsOf: markedSongs + markedAlbums + markedPerformances)
        os_log("%@ objects ready for delete", log: Log_CoreData, String(describing: deleteables.count))
        deleteables.forEach { context.delete($0) }
    }
    
}
