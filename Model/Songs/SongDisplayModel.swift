import Foundation

public struct SongDisplayModel: Model {

    private let song: sSong
    public let uuid: String
    
    public init(song: sSong) {
        self.song = song
        self.uuid = song.uuid
    }
    
    public var uploadAllowed: Bool {
        uuid != .invalid
    }

}

public extension SongDisplayModel {
    
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

    var firstPerformance: sPerformance? {
        performances?.first
    }

}

extension SongDisplayModel: Equatable {

}
