//
//  Performance.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

// swiftlint:disable type_name
struct sPerformance: Codable, Editable {

    let uuid: String
    let venue: String
    let songs: [sSong]
    let date: Double
    var lbNumbers: [Int]?

    var id: String {
        venue + String(date)
    }
    
    init(performance: Performance) {
        uuid = performance.uuid!
        venue = performance.venue!
        let arr = performance.songs?.array as? [Song] ?? []
        self.songs = arr.compactMap { sSong.init(uuid: $0.uuid!, title: $0.title!, author: $0.songAuthor)}
        self.lbNumbers = performance.lbNumbers
        self.date = performance.date
    }
    
    init(uuid: String, venue: String, songs: [sSong], date: Double, lbNumbers: [Int]? = nil) {
        self.uuid = uuid
        self.venue = venue
        self.songs = songs
        self.date = date
        self.lbNumbers = lbNumbers
    }

}

extension sPerformance: Hashable {}
