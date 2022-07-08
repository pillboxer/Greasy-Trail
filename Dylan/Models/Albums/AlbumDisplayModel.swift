//
//  AlbumDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation

struct AlbumDisplayModel {
    
    let album: sAlbum
    
    init(album: sAlbum) {
        self.album = album
    }
    
}

extension AlbumDisplayModel {
    
    var songTitles: [String] {
        album.songs.compactMap { $0.title }
    }

}
