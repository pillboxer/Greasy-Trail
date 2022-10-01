import Foundation
import Core

// swiftlint:disable type_name
public struct sPerformance: Decodable, Equatable {

    public var uuid: String
    public var venue: String
    public var songs: [sSong]
    public var date: Double
    public var dateFormat: PerformanceDateFormat
    public var lbNumbers: [Int]
    public var isFavorite: Bool
    
    public init(uuid: String,
                venue: String,
                songs: [sSong],
                date: Double,
                lbNumbers: [Int] = [],
                isFavorite: Bool,
                dateFormat: PerformanceDateFormat) {
        self.uuid = uuid
        self.venue = venue
        self.songs = songs
        self.dateFormat = dateFormat
        self.date = date
        self.lbNumbers = lbNumbers
        self.isFavorite = isFavorite
    }

}

extension sPerformance: Hashable {}
