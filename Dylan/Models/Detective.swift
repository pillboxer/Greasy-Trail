//
//  Detective.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation
import OSLog
import CloudKit

public class Detective: ObservableObject {
        
    let manager: CloudKitManager
    
    init(_ manager: CloudKitManager) {
        self.manager = manager
    }
    
    func search(song title: String) async -> SongDisplayModel? {
        do {
            return try await manager.fetch(song: title)
        }
        catch let error {
            os_log("Error: Unable to search song:", String(describing: error))
            return nil
        }
    }
    
    func search(album title: String) async -> AlbumDisplayModel? {
        do {
            return try await manager.fetch(album: title)
        }
        catch let error {
            os_log("Error: Unable to search album:", String(describing: error))
            return nil
        }
    }
    
    // FIXME:
    func search(performance date: Double) async -> PerformanceDisplayModel? {
        do {
           return try await manager.fetch(performance: date)
        }
        catch let error {
            os_log("Error: Unable to search performance", String(describing: error))
            return nil
        }
    }
    
}
