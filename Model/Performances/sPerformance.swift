//
//  Performance.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

// swiftlint:disable type_name
public struct sPerformance: Codable, Editable {

    public let uuid: String
    public let venue: String
    let songs: [sSong]
    public let date: Double?
    public var lbNumbers: [Int]?

    var id: String {
        venue + String(date ?? 0)
    }
    
    public init(uuid: String, venue: String, songs: [sSong], date: Double?, lbNumbers: [Int]? = nil) {
        self.uuid = uuid
        self.venue = venue
        self.songs = songs
        self.date = date
        self.lbNumbers = lbNumbers
    }

}

extension sPerformance: Hashable {}
