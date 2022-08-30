//
//  PerformanceDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Foundation
import Core

public struct PerformanceDisplayModel: Model, CustomStringConvertible {

    public let sPerformance: sPerformance
    public let uuid: String

    public init(sPerformance: sPerformance) {
        self.sPerformance = sPerformance
        self.uuid = sPerformance.uuid
    }
    
    public var uploadAllowed: Bool {
        let songUUIDs = songs.map { $0.uuid }
        return uuid != .invalid
        && !(songUUIDs.contains(.invalid))
        && !(lbNumbers.contains(0))
    }
    
    public var description: String {
        """
        \n
        \(venue) - \(date ?? 0)
        -- SONGS --
        \(songTitles.joined(separator: "\n"))
        -- LB Numbers --
        \(lbNumbers)
        """
    }

}

public extension PerformanceDisplayModel {

    var songs: [sSong] {
        sPerformance.songs
    }

    var songTitles: [String] {
        sPerformance.songs.map { $0.title }
    }

    var venue: String {
        sPerformance.venue
    }
    
    var date: Double? {
        sPerformance.date
    }

    var lbNumbers: [Int] {
        sPerformance.lbNumbers
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

extension PerformanceDisplayModel: Equatable {
    
    public static func == (lhs: PerformanceDisplayModel, rhs: PerformanceDisplayModel) -> Bool {
        lhs.sPerformance == rhs.sPerformance
    }
  
}
