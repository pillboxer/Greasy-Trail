//
//  NSManagedObjectContext+Extensions.swift
//  Dylan
//
//  Created by Henry Cooper on 07/07/2022.
//

import CoreData
import OSLog

extension NSManagedObjectContext {
    // swiftlint:disable identifier_name
    func fetchAndWait<T: NSManagedObject>(_ t: T.Type,
                                          with predicate: NSPredicate? = nil,
                                          sortDescriptors: [NSSortDescriptor]? = nil,
                                          fetchLimit: Int? = nil,
                                          propertiesToFetch: [String]? = nil) -> [T] {
        return syncPerform {
            let request: NSFetchRequest = T.fetchRequest()
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            request.propertiesToFetch = propertiesToFetch
            if let limit = fetchLimit {
                request.fetchLimit = limit
            }
            return (try? fetch(request) as? [T]) ?? []
        }
    }

    func performSave() {
        perform {
            self.saveWithTry()
        }
    }
    
    func syncSave() {
        syncPerform {
            self.saveWithTry()
        }
    }

    private func saveWithTry() {
        guard self.hasChanges else {
            os_log("No changes to save, returning", log: Log_CoreData)
            return
        }
        do {
            try self.save()
        } catch {
            os_log("Context unable to save. Error: %{public}@",
                   log: Log_CoreData,
                   type: .error,
                   String(describing: error))
        }
    }
    
    @discardableResult
    func syncPerform<T>(_ block: () -> T) -> T {
        var result: T?
        // Call the framework version
        performAndWait {
            result = block()
        }
        return result!
    }
}
