import Foundation

public struct AlbumDisplayModel: Model {
    
    public let album: sAlbum
    public let uuid: String
    
    public init(album: sAlbum) {
        self.album = album
        self.uuid = album.uuid
    }
    
    public var uploadAllowed: Bool {
        let songUUIDs = songs.map { $0.uuid }
        return uuid != .invalid
        && !(songUUIDs.contains(.invalid))
        
    }
    
}

public extension AlbumDisplayModel {
    
    var isFavorite: Bool {
        album.isFavorite
    }
    
    var title: String {
        album.title
    }
    
    var songs: [sSong] {
        album.songs
    }
    
    var releaseDate: Double {
        album.releaseDate
    }
    
}

extension AlbumDisplayModel: Equatable {}
