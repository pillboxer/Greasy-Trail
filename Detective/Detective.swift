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
    
    public func search(album id: NSManagedObjectID) -> Effect<AnyModel?, Never> {
        logger.log("Searching album by ID \(id, privacy: .public)")
        return fetchAlbumModel(for: id)
    }

    public func search(song string: String) -> Effect<AnyModel?, Never> {
        logger.log("Searching song: \(string, privacy: .public)")
        return fetchSongModel(for: string)
    }

    public func search(album string: String) -> Effect<AnyModel?, Never> {
        logger.log("Searching album: \(string, privacy: .public)")
        return fetchAlbumModel(for: string)
    }

    public func search(performance date: Double) -> Effect<AnyModel?, Never> {
        logger.log("Searching date: \(date, privacy: .public)")
        return fetchPerformanceModel(for: date)
    }
    
    public func search(performance uuid: String) -> Effect<AnyModel?, Never> {
        logger.log("Searching uuid: \(uuid, privacy: .public)")
        return fetchPerformanceModel(for: uuid)
    }
    
    func objects<T: NSManagedObject>(_ object: T.Type,
                                     including song: Song,
                                     context: NSManagedObjectContext,
                                     completion: @escaping ([T]) -> Void) {
        let predicate = NSPredicate(format: "songs CONTAINS %@", song)
        context.performFetch(T.self, with: predicate, completion: completion)
    }

}
