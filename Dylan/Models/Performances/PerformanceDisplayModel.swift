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
    
    var songs: [sSong] {
        sPerformance.songs
    }
    
    var songTitles: [String] {
        sPerformance.songs.map { $0.title }
    }
    
    var venue: String {
        sPerformance.venue
    }
    
    var lbNumbers: [Int]? {
        sPerformance.lbNumbers
    }
    
    var albums: [sAlbum] {
        songs.compactMap { $0.albums?.first }
        
    }
    
    func officialURL() -> URL? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let performanceDate = sPerformance.date else {
            return nil
        }
        let date = Date(timeIntervalSince1970: performanceDate)
        let string = formatter.string(from: date)
        return URL(string: "https://www.bobdylan.com/date/\(string)")!
    }

    
}

extension PerformanceDisplayModel: Equatable {}
