//
//  AlbumDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation

struct AlbumDisplayModel: Model {

    let album: sAlbum
    let uuid: String
    init(album: sAlbum) {
        self.album = album
        self.uuid = album.uuid
    }

}

extension AlbumDisplayModel {

    var title: String {
        album.title
    }

    var songs: [sSong] {
        album.songs
    }

}

extension AlbumDisplayModel: Equatable {}
