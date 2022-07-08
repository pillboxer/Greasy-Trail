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
        fetch(song: title)
    }
    
    func search(album title: String) -> AlbumDisplayModel? {
        fetch(album: title)
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
