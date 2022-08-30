//
//  AlbumDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation

public struct AlbumDisplayModel: Model {

    let album: sAlbum
    public let uuid: String
    
    public init(album: sAlbum) {
        self.album = album
        self.uuid = album.uuid
    }
    
    public var uploadAllowed: Bool {
        uuid != .invalid
    }

}

public extension AlbumDisplayModel {

    var title: String {
        album.title
    }

    var songs: [sSong] {
        album.songs
    }

}

extension AlbumDisplayModel: Equatable {}
