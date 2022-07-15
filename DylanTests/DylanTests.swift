//
//  DylanTests.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/06/2022.
//

import XCTest
import CoreData
@testable import Greasy_Trail

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
}

extension DylanTests {
    
    private func song(title: String, author: String? = NSLocalizedString("default_author", comment: "")) -> Song {
        let context = container.viewContext
        let song = Song(context: context)
        song.title = title
        song.author = author
        try! context.save()
        return song
    }
    
    @discardableResult
    private func createAndSaveHighway61Revisited() -> [Song] {
        let context = container.viewContext

        let songs = [song(title: DummyModel.tLikeARollingStone),
                     song(title: DummyModel.tTombstoneBlues),
                     song(title: DummyModel.tItTakesALotToLaugh),
                     song(title: DummyModel.tFromABuick6),
                     song(title: DummyModel.tBalladOfAThinMan),
                     song(title: DummyModel.tQueenJaneApproximately),
                     song(title: DummyModel.tHighway61Revisited),
                     song(title: DummyModel.tJustLikeTomThumbsBlues),
                     song(title: DummyModel.tDesolationRow)
                     ]
        let album = Album(context: context)
        album.songs = NSOrderedSet(array: songs)
        album.title = DummyModel.tHighway61Revisited
        album.releaseDate = DummyModel.dHighway61Revisited
        try! context.save()
        return songs
    }
    
}

