//
//  DummyModel.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

@testable import Dylan

struct DylanData {
    
    static var Highway61Revisited: Album {
        let songs: [Song] = [LikeARollingStone, Song(title: "It Takes A Lot To Laugh")]
        return Album(title: "Highway 61 Revisited", songs: songs)
    }
    
    static var LikeARollingStone: Song {
        Song(title: "Like A Rolling Stone")
    }
    
}
