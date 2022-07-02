//
//  DummyModel.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

@testable import Dylan

class DummyModel {
    
    // Public
    static var hw61Song: Song {
        Song(title: hw61Title, albums: [hw61AlbumRepresentation, beforeTheFloodAlbumRepresentation, realLiveAlbumRepresentation])
    }
    
    static var hw61AlbumRepresentation: Album {
        Album(title: hw61Title, songs: [], releaseDate: hw61ReleaseDate)
    }
    
    static var beforeTheFloodAlbumRepresentation: Album {
        Album(title: beforeTheFloodTitle, songs: [], releaseDate: beforeTheFloodReleaseDate)
    }
    
    static var realLiveAlbumRepresentation: Album {
        Album(title: realLiveTitle, songs: [], releaseDate: realLiveReleaseDate)
    }
    
    static var tombstoneBluesRecord: MockSongRecord {
        MockSongRecord(title: "Tombstone Blues")
    }
    
    static var hw61AlbumRecord: MockAlbumRecord {
        MockAlbumRecord(title: hw61Title, releaseDate: hw61ReleaseDate)
    }
    
    static var realLiveAlbumRecord: MockAlbumRecord {
        MockAlbumRecord(title: realLiveTitle, releaseDate: realLiveReleaseDate)
    }
    
    static let expectedAlbumsForTombstoneBlues = [hw61AlbumRepresentation, realLiveAlbumRepresentation]

    
    // Private
    
    static var hw61Title: String {
        "Highway 61 Revisited"
    }
    
    private static var hw61ReleaseDate: Double {
        -139622400
    }
    
    private static var beforeTheFloodTitle: String {
        "Before The Flood"
    }
    
    private static var beforeTheFloodReleaseDate: Double {
        140918400
    }
    
    private static var realLiveTitle: String {
        "Real Live"
    }
    
    private static var realLiveReleaseDate: Double {
        470534400
    }
        
}
