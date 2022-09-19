import Foundation

// swiftlint:disable type_name
public struct sPerformance: Codable {

    public var uuid: String
    public var venue: String
    public var songs: [sSong]
    public var date: Double
    public var lbNumbers: [Int]
    public var isFavorite: Bool
    
    public init(uuid: String,
                venue: String,
                songs: [sSong],
                date: Double,
                lbNumbers: [Int] = [],
                isFavorite: Bool) {
        self.uuid = uuid
        self.venue = venue
        self.songs = songs
        self.date = date
        self.lbNumbers = lbNumbers
        self.isFavorite = isFavorite
    }

}

extension sPerformance: Hashable {}
