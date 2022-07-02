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
    
    private func searchTombstoneBlues() async -> SongDisplayModel? {
        let songToSearch = "Tombstone Blues"
        let mockSongRecord = DummyModel.tombstoneBluesRecord
        let mockAlbumRecords = [DummyModel.hw61AlbumRecord, DummyModel.realLiveAlbumRecord]
        let database = MockSongDatabase(songRecord: mockSongRecord, albums: mockAlbumRecords)
        let detective = Detective(database)
        return await detective.search(song: songToSearch)
    }
    
    func testSongSearchReturnsCorrectAlbums() async {
        let result = await searchTombstoneBlues()
        let albums = result?.albums
        XCTAssert(albums == DummyModel.expectedAlbumsForTombstoneBlues && result?.numberOfAlbums == DummyModel.expectedAlbumsForTombstoneBlues.count)
    }
    
    func testSongSearchReturnsCorrectFirstAlbumAppearance() async {
        let result = await searchTombstoneBlues()
        XCTAssert(result?.firstAlbumAppearance == DummyModel.expectedAlbumsForTombstoneBlues.first)
    }
    
    func testSongSearchReturnsCorrectAuthor() async {
        let result = await searchTombstoneBlues()
        XCTAssert(result?.author == "Bob Dylan")
    }
    
    func testUnknownSongReturnsNilDisplayModel() async {
        let database = MockSongDatabase(songRecord: nil, albums: [])
        let detective = Detective(database)
        let result = await detective.search(song: "Brown Sugar")
        XCTAssertNil(result)
    }
    

}
