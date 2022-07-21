//
//  DummyModel+DisplayModels.swift
//  DylanTests
//
//  Created by Henry Cooper on 15/07/2022.
//

@testable import Greasy_Trail
import Foundation

// Songs
extension DummyModel {

   static var sdmLikeARollingStone: SongDisplayModel {
        SongDisplayModel(song: sLikeARollingStone)
    }

}

// Albums
extension DummyModel {

    static var admHighway61Revisited: AlbumDisplayModel {
        AlbumDisplayModel(album: aHighway61Revisited)
    }

}

// Performances
extension DummyModel {

    static var pdmNewport1965: PerformanceDisplayModel {
        PerformanceDisplayModel(sPerformance: pNewport1965)
    }

}
