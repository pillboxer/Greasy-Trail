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

    init(_ container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }

    func search(song title: String) -> Effect<Model?> {
        os_log("Searching song: %{public}@", log: Log_Detective, title)
        return fetchModel(for: title)
    }

    func search(album title: String) -> Effect<Model?> {
        os_log("Searching album: %{public}@", log: Log_Detective, title)
        return fetch(album: title)
    }

    func search(performance date: Double) -> Effect<Model?> {
        os_log("Searching date: %{public}@", log: Log_Detective, String(describing: date))
        return fetch(performance: date)
    }

    func objects<T: NSManagedObject>(_ object: T.Type,
                                     including song: Song,
                                     context: NSManagedObjectContext) -> [T] {
        let predicate = NSPredicate(format: "songs CONTAINS %@", song)
        let objects = context.fetchAndWait(T.self, with: predicate)
        return objects
    }
    
    func objects<T: NSManagedObject>(_ object: T.Type,
                                     including song: Song,
                                     context: NSManagedObjectContext,
                                     completion: @escaping ([T]) -> Void) {
        let predicate = NSPredicate(format: "songs CONTAINS %@", song)
        context.performFetch(T.self, with: predicate, completion: completion)
    }

}
