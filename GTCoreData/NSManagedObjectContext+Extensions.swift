import CoreData
import os
import Core

let logger = Logger(subsystem: .subsystem, category: "")

extension NSManagedObjectContext {
    // swiftlint:disable identifier_name
    public func fetchAndWait<T: NSManagedObject>(_ t: T.Type,
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
    
    public func performFetch<T: NSManagedObject>(_ t: T.Type,
                                                 with predicate: NSPredicate? = nil,
                                                 sortDescriptors: [NSSortDescriptor]? = nil,
                                                 fetchLimit: Int? = nil,
                                                 propertiesToFetch: [String]? = nil,
                                                 completion: @escaping ([T]) -> Void) {
        return perform {
            let request: NSFetchRequest = T.fetchRequest()
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            request.propertiesToFetch = propertiesToFetch
            if let limit = fetchLimit {
                request.fetchLimit = limit
            }
            completion((try? self.fetch(request) as? [T]) ?? [])
        }
    }

    public func performSave() {
        perform {
            self.saveWithTry()
        }
    }
    
    public func asyncSave() async {
        await perform {
            self.saveWithTry()
        }
    }
    
    private func saveWithTry() {
        guard self.hasChanges else {
            logger.log("No changes to save")
            return
        }
        do {
            try self.save()
        } catch {
            logger.log(level: .error,
                       "Unable to save changes with error: \(String(describing: error), privacy: .public)")
        }
    }
    
    @discardableResult
    public func syncPerform<T>(_ block: () -> T) -> T {
        var result: T?
        // Call the framework version
        performAndWait {
            result = block()
        }
        return result!
    }
}
