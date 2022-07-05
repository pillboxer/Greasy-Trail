//
//  DummyModel+Albums.swift
//  DylanTests
//
//  Created by Henry Cooper on 04/07/2022.
//

@testable import Dylan


extension DummyModel {
    
    static var aHighway61Revisited: Album {
        let songs = [sLikeARollingStone,
                     sTombstoneBlues,
                     sItTakesALotToLaugh,
                     sFromABuick6,
                     sBalladOfAThinMan,
                     sQueenJaneApproximately,
                     sHighway61Revisited,
                     sJustLikeTomThumbsBlues,
                     sDesolationRow]
        return Album(title: tHighway61Revisited, songs: songs, releaseDate: rHighway61Revisited)
    }
    
}