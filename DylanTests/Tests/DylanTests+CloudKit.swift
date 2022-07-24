//
//  DylanTests+CloudKit.swift
//  DylanTests
//
//  Created by Henry Cooper on 16/07/2022.
//

@testable import Greasy_Trail
import XCTest
import Foundation

extension DylanTests {

    func testStartingCloudKitWithFullDatabaseResultsInFullLocalDatabase() async throws {

        let expectedAlbums = [DummyModel.aHighway61Revisited]
        let expectedPerformances = [DummyModel.pNewport1965]
        let expectedSongs = DummyModel.aHighway61Revisited.songs + [DummyModel.sMaggiesFarm]

        let songRecords = DummyModel.highway61RevisitedAlbumSongRecords + [DummyModel.msMaggiesFarm]
        
        let albumRecords = [DummyModel.maHighway61Revisited]
        let albumSongRecords = DummyModel.highway61RevisitedAlbumSongRecords
        
        let performanceRecords = [DummyModel.mpNewport1965]
        let performanceSongRecords = DummyModel.newport1965SongRecords
        
        let metadataRecord = DummyModel.AppMetadataRecord

        let database = MockDatabase(songs: songRecords,
                                    albums: albumRecords,
                                    albumSongs: albumSongRecords,
                                    performances: performanceRecords,
                                    performanceSongs: performanceSongRecords,
        metadata: [metadataRecord])
        let manager = CloudKitManager(database, container: container)
        await manager.start()

        let context = container.newBackgroundContext()
        let albums = context.fetchAndWait(Album.self)
        let songs = context.fetchAndWait(Song.self)
        let performances = context.fetchAndWait(Performance.self)

        XCTAssert(albums.count == expectedAlbums.count &&
                  performances.count == expectedPerformances.count &&
                  songs.count == expectedSongs.count)

    }

}
