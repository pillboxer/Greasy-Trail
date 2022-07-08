//
//  DylanTests.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/06/2022.
//

import XCTest
import CoreData
@testable import Dylan

class DylanTests: XCTestCase {
    
    var container: NSPersistentContainer!
    
    override func setUpWithError() throws {
        container = PersistenceController(inMemory: true).container
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
    
    func testStartingCloudKitWithFullDatabaseResultsInFullLocalDatabase() async throws  {
        
        let expectedAlbums = [DummyModel.aHighway61Revisited]
        let expectedPerformances = [DummyModel.pNewport1965]
        let expectedSongs = DummyModel.aHighway61Revisited.songs + [DummyModel.sMaggiesFarm]
        
        let songRecords = DummyModel.highway61RevisitedAlbumSongRecords + [DummyModel.msMaggiesFarm]
        
        let albumRecords = [DummyModel.maHighway61Revisited]
        let albumSongRecords = DummyModel.highway61RevisitedAlbumSongRecords
        let performanceRecords = [DummyModel.mpNewport1965]
        let performanceSongRecords = DummyModel.newport1965SongRecords
        
        let database = MockDatabase(songs: songRecords, albums: albumRecords, albumSongs: albumSongRecords, performances: performanceRecords, performanceSongs: performanceSongRecords)
        let manager = CloudKitManager(database, container: container)
        try await manager.start()
        
        let context = container.newBackgroundContext()
        let albums = context.fetchAndWait(Album.self)
        let songs = context.fetchAndWait(Song.self)
        let performances = context.fetchAndWait(Performance.self)
        
        XCTAssert(albums.count == expectedAlbums.count && performances.count == expectedPerformances.count && songs.count == expectedSongs.count)
        
    }
}


