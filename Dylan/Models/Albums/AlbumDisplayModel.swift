//
//  AlbumDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation

struct AlbumDisplayModel {
    
    let album: Album
    
    init(album: Album) {
        self.album = album
    }
    
}

extension AlbumDisplayModel {
    
    var songTitles: [String] {
        album.songs.compactMap { $0.title }
    }

}
