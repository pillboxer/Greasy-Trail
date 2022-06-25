//
//  Album.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

public struct Album: Codable {
    
    let title: String
    let songs: [Song]
    let releaseDate: Double
    
}

extension Album {
    
   public func contains(_ song: Song) -> Bool {
        songs.contains { $0 == song }
    }
    
}
