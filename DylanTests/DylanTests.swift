//
//  DylanTests.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/06/2022.
//

import XCTest
@testable import Dylan

class DylanTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSongSearchProvidesCorrectData() async {
        let expectedAlbums = [DummyModel.hw61AlbumRepresentation, DummyModel.beforeTheFloodAlbumRepresentation, DummyModel.realLiveAlbumRepresentation]
        let record = DummyModel.hw61SongRecord
        let database = MockSongDatabase(record)
        let detective = Detective(database)
        let model = await detective.search(song: "Highway 61 Revisited")!
        guard model.song == DummyModel.hw61Song else {
            return XCTAssert(false)
        }
        XCTAssert(expectedAlbums == model.albums)
    }
    
    func testSongThatDoesntExistProvidesNilData() async {
        let database = MockSongDatabase(nil)
        let detective = Detective(database)
        let model = await detective.search(song: "Not Exist")
        XCTAssert(model == nil)
    }

}
