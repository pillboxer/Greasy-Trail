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
    
    /// Finds live performances of the given song
    func search(song title: String) async -> SongDisplayModel? {
        return await manager.fetch(song: title)
    }
    
}
