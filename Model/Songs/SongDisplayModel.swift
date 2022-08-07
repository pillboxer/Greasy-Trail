//
//  SongDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import Foundation

/// The Information Returned Upon Requesting Information About A Song
public struct SongDisplayModel: Model {

    private let song: sSong
    public let uuid: String
    
    public init(song: sSong) {
        self.song = song
        self.uuid = song.uuid
    }

}

public extension SongDisplayModel {

    var title: String {
        song.title
    }

    var firstAlbumAppearance: sAlbum? {
        song.albums?.first
    }

    var numberOfAlbums: Int {
        song.albums?.count ?? 0
    }

    var albums: [sAlbum]? {
        song.albums
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
