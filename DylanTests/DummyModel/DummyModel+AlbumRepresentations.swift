//
//  DummyModel+AlbumRepresentations.swift
//  DylanTests
//
//  Created by Henry Cooper on 04/07/2022.
//

@testable import Dylan

extension DummyModel {
    
    static var beforeTheFloodAlbumRepresentation: Album {
        Album(title: tBeforeTheFlood, songs: [], releaseDate: rBeforeTheFlood)
    }
    
    static var realLiveAlbumRepresentation: Album {
        Album(title: tRealLive, songs: [], releaseDate: rRealLive)
    }
    
    static var hw61AlbumRepresentation: Album {
        Album(title: tHighway61Revisited, songs: [], releaseDate: rHighway61Revisited)
    }
    
    
}

extension DummyModel {
    
    static var rHighway61Revisited: Double {
        -139622400
    }
    
    static var tBeforeTheFlood: String {
        "Before The Flood"
    }
    
    static var rBeforeTheFlood: Double {
        140918400
    }
    
    static var tRealLive: String {
        "Real Live"
    }
    
    static var rRealLive: Double {
        470534400
    }
    
}
