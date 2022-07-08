//
//  PerformanceDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Foundation

struct PerformanceDisplayModel {
    
    let sPerformance: sPerformance
    
    init(sPerformance: sPerformance) {
        self.sPerformance = sPerformance
    }
    
}

extension PerformanceDisplayModel {
    
    var songTitles: [String] {
        sPerformance.songs.compactMap { $0.title }
    }
    
    var venue: String {
        sPerformance.venue
    }
    
}
