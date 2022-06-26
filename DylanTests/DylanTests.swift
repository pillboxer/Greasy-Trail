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
        let albumReferences = [MockAlbumReference(title: "Highway 61 Revisited"), MockAlbumReference(title: "Before The Flood"), MockAlbumReference(title: "Real Live")]
        let record = MockSongRecord(title: "Highway 61 Revisited", references: albumReferences)
        let database = MockSongDatabase(record)
        let detective = Detective(database)
        let model = await detective.search(song: "Highway 61 Revisited")!
        XCTAssert(model.numberOfAlbums == albumReferences.count)
    }

}
