import Core
import Foundation
import CoreData
import GTCoreData
import Model
import os
import ComposableArchitecture

let logger = Logger(subsystem: .subsystem, category: "Detective")

public class Detective: ObservableObject {

    let container: NSPersistentContainer

    public init(_ container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    public func search(performance id: NSManagedObjectID) -> Effect<AnyModel?, Never> {
        logger.log("Searching performance by ID: \(id, privacy: .public)")
        return fetchPerformanceModel(for: id)
    }
    
    public func search(song id: NSManagedObjectID) -> Effect<AnyModel?, Never> {
        logger.log("Searching song by ID: \(id, privacy: .public)")
        return fetchSongModel(for: id)
    }

    public func search(song title: String) -> Effect<AnyModel?, Never> {
        logger.log("Searching song: \(title, privacy: .public)")
        return fetchModel(for: title)
    }

    public func search(album title: String) -> Effect<AnyModel?, Never> {
        logger.log("Searching album: \(title, privacy: .public)")
        return fetch(album: title)
    }

    public func search(performance date: Double) -> Effect<AnyModel?, Never> {
        logger.log("Searching date: \(date, privacy: .public)")
        return fetch(performance: date)
    }
    
    func objects<T: NSManagedObject>(_ object: T.Type,
                                     including song: Song,
                                     context: NSManagedObjectContext,
                                     completion: @escaping ([T]) -> Void) {
        let predicate = NSPredicate(format: "songs CONTAINS %@", song)
        context.performFetch(T.self, with: predicate, completion: completion)
    }

}
