import Foundation

public struct SongDisplayModel: Model {

    public let song: sSong
    
    public init(song: sSong) {
        self.song = song
    }
    
    public var uploadAllowed: Bool {
        uuid != .invalid && !title.isEmpty
    }

}

public extension SongDisplayModel {
    
    var uuid: String {
        song.uuid
    }
    
    var isFavorite: Bool {
        song.isFavorite
    }

    var title: String {
        song.title
    }

    var author: String {
        song.author
    }

    var performances: [sPerformance]? {
        song.performances
    }

    var baseSongUUID: String? {
        song.baseSongUUID
    }

}

extension SongDisplayModel: Equatable {}
