import Core
import CoreData
import OSLog

public let Log_CoreData = OSLog(subsystem: .subsystem, category: "Core Data")

public class PersistenceController {
    
    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?

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
    
    public func reset() async throws {
        let context = newBackgroundContext()
        let entityNames = self.container.managedObjectModel.entities.map({ $0.name! })
        try await context.perform {
            for entity in entityNames {
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                do {
                    try context.execute(deleteRequest)
                }
            }
        }
        await context.asyncSave()
        self.lastFetchDate = .distantPast
    }
}
