//
//  Detective.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation
import OSLog
import CoreData
import Combine
import GTCoreData
import Model
import GTLogging
import ComposableArchitecture

public class Detective: ObservableObject {

    let container: NSPersistentContainer

    public init(_ container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    public func search(performance id: NSManagedObjectID) -> Effect<AnyModel?, Never> {
        os_log("Searching performance by ID: %{public}@", log: Log_Detective, id)
        return fetchPerformanceModel(for: id)
    }
    
    public func search(song id: NSManagedObjectID) -> Effect<AnyModel?, Never> {
        os_log("Searching song by ID: %{public}@", log: Log_Detective, id)
        return fetchSongModel(for: id)
    }

    public func search(song title: String) -> Effect<AnyModel?, Never> {
        os_log("Searching song: %{public}@", log: Log_Detective, title)
        return fetchModel(for: title)
    }

    public func search(album title: String) -> Effect<AnyModel?, Never> {
        os_log("Searching album: %{public}@", log: Log_Detective, title)
        return fetch(album: title)
    }

    public func search(performance date: Double) -> Effect<AnyModel?, Never> {
        os_log("Searching date: %{public}@", log: Log_Detective, String(describing: date))
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
