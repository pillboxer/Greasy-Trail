//
//  Detective.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation
import OSLog
import CoreData

public class Detective: ObservableObject {
    
    let container: NSPersistentContainer
    
    init(_ container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    func search(song title: String) -> SongDisplayModel? {
        os_log("Searching song: %@", log: Log_Detective, title)
        return fetch(song: title)
    }
    
    func search(album title: String) -> AlbumDisplayModel? {
        os_log("Searching album: %@", log: Log_Detective, title)
        return fetch(album: title)
    }
    
    func search(performance date: Double) -> PerformanceDisplayModel? {
        os_log("Searching date: %@", log: Log_Detective, String(describing: date))
        return fetch(performance: date)
    }

    func objects<T: NSManagedObject>(_ object: T.Type, including song: Song, context: NSManagedObjectContext) -> [T] {
        var toReturn: [T] = []
        context.performAndWait {
            // Find all albums which contain a given song
            let predicate = NSPredicate(format: "songs CONTAINS %@", song)
            let objects = context.fetchAndWait(T.self, with: predicate)
            toReturn = objects
        }
        return toReturn
    }
    
    
}
