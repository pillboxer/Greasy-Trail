//
//  MockDatabase.swift
//  DylanTests
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation

@testable import Greasy_Trail
import CloudKit

class MockDatabase: DatabaseType {

    var songs: [MockSongRecord]?
    var albums: [MockAlbumRecord]?
    var performances: [MockPerformanceRecord]?
    var albumSongs: [MockSongRecord]?
    var performanceSongs: [MockSongRecord]?

    init(songs: [MockSongRecord],
         albums: [MockAlbumRecord],
         albumSongs: [MockSongRecord],
         performances: [MockPerformanceRecord],
         performanceSongs: [MockSongRecord]) {
        self.songs = songs
        self.albums = albums
        self.performances = performances
        self.albumSongs = albumSongs
        self.performanceSongs = performanceSongs
    }

    func add(_ operation: CKDatabaseOperation) {
        //
    }

    func fetchPagedResults(with query: CKQuery) async -> ([(CKRecord.ID, Result<RecordType, Error>)]) {
        var results: [(CKRecord.ID, Result<RecordType, Error>)] = []
        if let songs = songs {
            for song in songs {
                let result = Result<RecordType, Error>.success(song)
                results.append((song.recordID, result))
            }
            self.songs = nil
            return results
        } else if let albums = albums {
            var results: [(CKRecord.ID, Result<RecordType, Error>)] = []
            for album in albums {
                let result = Result<RecordType, Error>.success(album)
                results.append((album.recordID, result))
            }
            self.albums = nil
            return results
        } else if let performances = performances {
            var results: [(CKRecord.ID, Result<RecordType, Error>)] = []
            for performance in performances {
                let result = Result<RecordType, Error>.success(performance)
                results.append((performance.recordID, result))
                return results
            }
            self.performances = nil
            return results
        }

        return results
    }

    func recordTypes(for ids: [CKRecord.ID],
                     desiredKeys: [CKRecord.FieldKey]?) async throws -> [CKRecord.ID: Result<RecordType, Error>] {
        var toReturn: [CKRecord.ID: Result<RecordType, Error>] = [:]
        for (index, id) in ids.enumerated() {
            toReturn[id] = Result.success((albumSongs ?? performanceSongs ?? [])[index])
        }
        self.albumSongs = nil
        return toReturn
    }

}
