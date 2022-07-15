//
//  DummyModel+AlbumRepresentations.swift
//  DylanTests
//
//  Created by Henry Cooper on 04/07/2022.
//

@testable import Greasy_Trail

extension DummyModel {
    
    static var beforeTheFloodAlbumRepresentation: sAlbum {
        sAlbum(title: tBeforeTheFlood, songs: [], releaseDate: dBeforeTheFlood)
    }
    
    static var realLiveAlbumRepresentation: sAlbum {
        sAlbum(title: tRealLive, songs: [], releaseDate: dRealLive)
    }
    
    static var hw61AlbumRepresentation: sAlbum {
        sAlbum(title: tHighway61Revisited, songs: [], releaseDate: dHighway61Revisited)
    }
    
    
}

extension DummyModel {
    
    static var dHighway61Revisited: Double {
        -139622400
    }
    
    static var tBeforeTheFlood: String {
        "Before The Flood"
    }
    
    static var dBeforeTheFlood: Double {
        140918400
    }
    
    static var tRealLive: String {
        "Real Live"
    }
    
    static var dRealLive: Double {
        470534400
    }
    
}
