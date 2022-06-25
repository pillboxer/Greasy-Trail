//
//  Detective.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

public class Detective: ObservableObject {
    
    private let manager = CloudKitManager()
    
    /// Finds live performances of the given song
    func search(song title: String) async {
        let _ = await manager.fetch(song: title)
    }
    
}
