//
//  DummyModel+MockRecords.swift
//  DylanTests
//
//  Created by Henry Cooper on 04/07/2022.
//

import Foundation

// Songs
extension DummyModel {
    
    static var msLikeARollingStone: MockSongRecord {
        MockSongRecord(title: tLikeARollingStone)
    }
    
    static var msTombstoneBlues: MockSongRecord {
        MockSongRecord(title: tTombstoneBlues)
    }
    
    static var msItTakesALotToLaugh: MockSongRecord {
        MockSongRecord(title: tItTakesALotToLaugh)
    }
    
    static var msFromABuick6: MockSongRecord {
        MockSongRecord(title: tFromABuick6)
    }
    
    static var msBalladOfAThinMan: MockSongRecord {
        MockSongRecord(title: tBalladOfAThinMan)
    }
    
    static var msQueenJaneApproximately: MockSongRecord {
        MockSongRecord(title: tQueenJaneApproximately)
    }
    
    static var msHighway61Revisited: MockSongRecord {
        MockSongRecord(title: tHighway61Revisited)
    }
    
    static var msJustLikeTomThumbsBlues: MockSongRecord {
        MockSongRecord(title: tJustLikeTomThumbsBlues)
    }
    
    static var msDesolationRow: MockSongRecord {
        MockSongRecord(title: tDesolationRow)
    }

    
}

// Albums
extension DummyModel {
    
    private static var highway61RevisitedAlbumSongRecords: [MockSongRecord] {
        [msLikeARollingStone,
         msTombstoneBlues,
         msItTakesALotToLaugh,
         msFromABuick6,
         msBalladOfAThinMan,
         msQueenJaneApproximately,
         msHighway61Revisited,
         msJustLikeTomThumbsBlues,
         msDesolationRow]
    }
    
    static var hw61AlbumRecord: MockAlbumRecord {
        let songReferences = highway61RevisitedAlbumSongRecords.map { $0.asReferenceType() }
        return MockAlbumRecord(title: tHighway61Revisited, releaseDate: rHighway61Revisited, references: songReferences)
    }
    
    static var realLiveAlbumRecord: MockAlbumRecord {
        MockAlbumRecord(title: tRealLive, releaseDate: rRealLive)
    }
    
}
