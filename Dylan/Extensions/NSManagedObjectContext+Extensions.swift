//
//  NSManagedObjectContext+Extensions.swift
//  Dylan
//
//  Created by Henry Cooper on 07/07/2022.
//

import CoreData

extension NSManagedObjectContext {
    
    func fetchAndWait<T: NSManagedObject>(_ t: T.Type, with predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, propertiesToFetch: [String]? = nil) -> [T] {
        var values: [T] = []
        performAndWait {
            let request: NSFetchRequest = T.fetchRequest()
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            request.propertiesToFetch = propertiesToFetch
            if let limit = fetchLimit {
                request.fetchLimit = limit
            }
            values = (try? fetch(request) as? [T]) ?? []
        }
        return values

    }
    
}
