//
//  PersistenceController.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import CoreData

class PersistenceController {
    
    static let shared = PersistenceController()
    
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
    
    let container: NSPersistentContainer
        
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
            }
        }
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
}
