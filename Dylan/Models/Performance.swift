//
//  Performance.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

struct Performance: Codable {
    
    let venue: String
    let songs: [Song]
    let date: Double?
    var LBNumber: Double?
    
}
