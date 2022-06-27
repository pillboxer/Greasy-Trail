//
//  SongDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import Foundation

/// The Information Returned Upon Requesting Information About A Song
public struct SongDisplayModel {
    
    let song: Song
    
    init(song: Song) {
        self.song = song
    }
    
}

extension SongDisplayModel {
    
    var firstAlbumAppearance: Album? {
        song.albums?.first
    }
    
    var numberOfAlbums: Int {
        song.albums?.count ?? 0
    }
    
    var albums: [Album]? {
        song.albums
    }
    
    
}
