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
        && !venue.isEmpty
    }
    
    public var description: String {
        """
        \n
        \(venue) - \(date)
        -- SONGS --
        \(songTitles.joined(separator: "\n"))
        -- LB Numbers --
        \(lbNumbers)
        """
    }

}

public extension PerformanceDisplayModel {
    
    var isFavorite: Bool {
        sPerformance.isFavorite
    }
    
    var songs: [sSong] {
        sPerformance.songs
    }

    var songTitles: [String] {
        songs.map { $0.title }
            .filter { $0 != "BREAK" }
    }

    var venue: String {
        sPerformance.venue
    }
    
    var date: Double {
        sPerformance.date
    }

    var lbNumbers: [Int] {
        sPerformance.lbNumbers
    }
    
    var dateFormat: PerformanceDateFormat {
        sPerformance.dateFormat
    }

    func officialURL() -> URL? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Date(timeIntervalSince1970: sPerformance.date)
        let string = formatter.string(from: date)
        return URL(string: "https://www.bobdylan.com/date/\(string)")!
    }

}

extension PerformanceDisplayModel: Equatable {
    
    public static func == (lhs: PerformanceDisplayModel, rhs: PerformanceDisplayModel) -> Bool {
        lhs.sPerformance == rhs.sPerformance
    }
  
}
