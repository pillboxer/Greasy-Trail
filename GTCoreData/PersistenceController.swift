//
//  PersistenceController.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import CoreData
import OSLog
import GTLogging

public class PersistenceController {

    public static let shared = PersistenceController()

    static var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: PersistenceController.self)

        guard let url = bundle.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate momd file for xcdatamodeld")
        }

        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load momd file for xcdatamodeld")
        }

        return model
    }()

    public let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main", managedObjectModel: Self.managedObjectModel)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error configuring Core Data: \(error.localizedDescription)")
            } else {
                self.container.viewContext.automaticallyMergesChangesFromParent = true
            }
        }
    }

    public func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    public func reset() {

        let context = newBackgroundContext()
        let entityNames = self.container.managedObjectModel.entities.map({ $0.name!})
        context.perform {
            entityNames.forEach { entityName in
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

                do {
                    try context.execute(deleteRequest)
                    try context.save()
                } catch {
                    os_log("Could not delete all items: %{public}@",
                           log: Log_CoreData,
                           type: .error,
                           String(describing: error))
                }
            }
        }
    }
}
