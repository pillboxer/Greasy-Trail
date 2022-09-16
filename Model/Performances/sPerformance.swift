import Foundation

// swiftlint:disable type_name
public struct sPerformance: Codable, Editable {

    public var uuid: String
    public var venue: String
    public var songs: [sSong]
    public var date: Double
    public var lbNumbers: [Int]
    
    public init(uuid: String,
                venue: String,
                songs: [sSong],
                date: Double,
                lbNumbers: [Int] = []) {
        self.uuid = uuid
        self.venue = venue
        self.songs = songs
        self.date = date
        self.lbNumbers = lbNumbers
    }

}

extension sPerformance: Hashable {}
