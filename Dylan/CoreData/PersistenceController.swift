//
//  PersistenceController.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Main")
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
