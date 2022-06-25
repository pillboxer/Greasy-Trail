//
//  SongDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import Foundation

/// The Information Returned Upon Requesting Information About A Song
struct SongDisplayModel {
    
    private let song: Song
    
    init(song: Song) {
        self.song = song
    }
    
}
