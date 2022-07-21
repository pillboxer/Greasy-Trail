//
//  DummyModel+Albums.swift
//  DylanTests
//
//  Created by Henry Cooper on 04/07/2022.
//

@testable import Greasy_Trail

extension DummyModel {

    static var aHighway61Revisited: sAlbum {
        let songs = [sLikeARollingStone,
                     sTombstoneBlues,
                     sItTakesALotToLaugh,
                     sFromABuick6,
                     sBalladOfAThinMan,
                     sQueenJaneApproximately,
                     sHighway61Revisited,
                     sJustLikeTomThumbsBlues,
                     sDesolationRow]
        return sAlbum(title: tHighway61Revisited, songs: songs, releaseDate: dHighway61Revisited)
    }

}
