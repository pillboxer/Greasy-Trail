//
//  Performance.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

struct sPerformance: Codable {
    
    let venue: String
    let songs: [sSong]?
    let date: Double?
    var LBNumbers: [Double]?
    
    var id: String {
        venue + String(date ?? 0) 
    }
    
}
