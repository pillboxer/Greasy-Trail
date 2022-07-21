//
//  DylanTests+DisplayModel.swift
//  DylanTests
//
//  Created by Henry Cooper on 16/07/2022.
//

import XCTest

@testable import Greasy_Trail

extension DylanTests {

    func testAlbumDisplayModelTitleIsCorrect() {
        let model = DummyModel.admHighway61Revisited
        let expectedTitle = DummyModel.tHighway61Revisited
        XCTAssert(model.title == expectedTitle)
    }

    func testAlbumDisplayModelSongsAreCorrect() {
        let model = DummyModel.admHighway61Revisited
        let expectedSongs = DummyModel.aHighway61Revisited.songs
        XCTAssert(model.songs == expectedSongs)
    }

}
