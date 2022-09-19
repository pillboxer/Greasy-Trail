import Foundation

// swiftlint:disable type_name
public struct sAlbum: Codable, Equatable, Identifiable {

    public let title: String
    let uuid: String
    let songs: [sSong]
    public let releaseDate: Double
    var isFavorite: Bool

    public var id: String {
        title + String(releaseDate)
    }
    
    public init(uuid: String, title: String, songs: [sSong], releaseDate: Double, isFavorite: Bool) {
        self.uuid = uuid
        self.title = title
        self.songs = songs
        self.releaseDate = releaseDate
        self.isFavorite = isFavorite
    }

}

extension sAlbum {

   public func contains(_ song: sSong) -> Bool {
        songs.contains { $0 == song }
    }

}
extension sAlbum: Hashable {}
