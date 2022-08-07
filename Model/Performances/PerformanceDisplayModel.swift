//
//  PerformanceDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Foundation
import GTFormatter

public struct PerformanceDisplayModel: Model {

    let formatter = GTFormatter.Formatter()
    public let sPerformance: sPerformance
    public let uuid: String

    public init(sPerformance: sPerformance) {
        self.sPerformance = sPerformance
        self.uuid = sPerformance.uuid
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
    
    var date: String {
        formatter.dateString(of: sPerformance.date)
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

extension PerformanceDisplayModel: Equatable {
    
    public static func == (lhs: PerformanceDisplayModel, rhs: PerformanceDisplayModel) -> Bool {
        lhs.sPerformance == rhs.sPerformance
    }
  
}
