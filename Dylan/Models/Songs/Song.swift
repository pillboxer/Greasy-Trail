//
//  Song.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

public struct Song: Codable {
    
    let title: String
    var author: String?
    var performances: [Performance]?
    var albums: [Album]?    
}

extension Song: Equatable {
    
    public static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.title == rhs.title
    }
    
}
