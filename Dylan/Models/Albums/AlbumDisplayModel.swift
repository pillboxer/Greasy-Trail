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
    
    var title: String {
        album.title
    }
    
    var songTitles: [String] {
        album.songs.compactMap { $0.title }
    }
    
    var songsIgnoringBreaks: [String] {
        songTitles.filter { $0 != "BREAK" }
    }


}
