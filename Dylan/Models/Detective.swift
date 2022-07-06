//
//  Detective.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation
import CloudKit

public class Detective: ObservableObject {
        
    let manager: CloudKitManager
    
    init(_ database: DatabaseType = DylanDatabase) {
        self.manager = CloudKitManager(database)
    }
    
    func search(song title: String) async -> SongDisplayModel? {
        try? await manager.fetch(song: title)
    }
    
    func search(album title: String) async -> AlbumDisplayModel? {
        try? await manager.fetch(album: title)
    }
    
    // FIXME:
    func search(performance date: String) async -> AlbumDisplayModel? {
        print("Looking for date \(date)")
        return nil
    }
    
}
