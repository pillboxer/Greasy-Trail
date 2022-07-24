//
//  DylanTests.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/06/2022.
//

import XCTest
import CoreData
@testable import Greasy_Trail
import SwiftUI

class DylanTests: XCTestCase {

    var container: NSPersistentContainer!
    let formatter = Greasy_Trail.Formatter() 

    override func setUpWithError() throws {
        container = PersistenceController(inMemory: true).container
    }

    func testSearchSongResultsInCorrectDisplayModel() {
        createAndSaveHighway61Revisited()
        let expectedDisplayModel = DummyModel.sdmLikeARollingStone
        let detective = Detective(container)
        let resultDisplayModel = detective.search(song: DummyModel.tLikeARollingStone)
        XCTAssert(resultDisplayModel == expectedDisplayModel)
    }

    func testSearchNonExistantSongResultsInNil() {
        let detective = Detective(container)
        let resultDisplayModel = detective.search(song: "Hey Jude")
        XCTAssertNil(resultDisplayModel)
    }

    func testSearchAlbumResultsInCorrectDisplayModel() {
        let expectedDisplayModel = DummyModel.admHighway61Revisited
        createAndSaveHighway61Revisited()

        let detective = Detective(container)
        let resultDisplayModel = detective.search(album: DummyModel.tHighway61Revisited)
        XCTAssert(resultDisplayModel == expectedDisplayModel)
    }

    func testSearchNonExistantAlbumResultsInNil() {
        let detective = Detective(container)
        let resultDisplayModel = detective.search(album: "Rubber Soul")
        XCTAssertNil(resultDisplayModel)
    }

    func testSearchNonExistantPerformanceResultsInNil() {
        let detective = Detective(container)
        let resultDisplayModel = detective.search(performance: 1)
        XCTAssertNil(resultDisplayModel)
    }

    func testSearchPerformanceResultsInCorrectDisplayModel() {
        createAndSaveNewport1965()
        let expectedDisplayModel = DummyModel.pdmNewport1965
        let detective = Detective(container)
        let resultDisplayModel = detective.search(performance: DummyModel.dNewport1965)
        XCTAssert(resultDisplayModel == expectedDisplayModel)
    }
    
    func testSearchWithMisspellingRegisteredResultsInCorrectDisplayModel() {
        createAndSaveHighway61Revisited()
        createAndSaveMisspellingsMetadata()
        let expectedDisplayModel = DummyModel.sdmLikeARollingStone
        let detective = Detective(container)
        let resultDisplayModel = detective.search(song: "lars")
        XCTAssert(resultDisplayModel == expectedDisplayModel)
    }
    
}
