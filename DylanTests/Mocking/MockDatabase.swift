//
//  MockDatabase.swift
//  DylanTests
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation
@testable import Dylan
import CloudKit

class MockSongDatabase: DatabaseType {
    
    private let songRecord: MockSongRecord?
    private let albums: [MockAlbumRecord]
    
    init(songRecord: MockSongRecord?, albums: [MockAlbumRecord]) {
        self.songRecord = songRecord
        self.albums = albums
    }
    
    func recordTypes(matching query: CKQuery, inZoneWith zoneID: CKRecordZone.ID?, desiredKeys: [CKRecord.FieldKey]?, resultsLimit: Int) async throws -> (matchResults: [(CKRecord.ID,
                                                                                                                                                                          Result<RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?) {
        var results: [(CKRecord.ID, Result<Dylan.RecordType, Error>)] = []
        if let songRecord = songRecord {
            let result = Result<RecordType, Error>.success(songRecord)
            results.append((songRecord.recordID, result))
        }
        return (results, nil)
    }
    
    func referenceRecordTypes(matching query: CKQuery, inZoneWith zoneID: CKRecordZone.ID?, desiredKeys: [CKRecord.FieldKey]?, resultsLimit: Int) async throws -> (matchResults: [(CKRecord.ID, Result<RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?) {
        var results: [(CKRecord.ID, Result<Dylan.RecordType, Error>)] = []
        for case let record as RecordType in albums {
                        let result = Result<RecordType, Error>.success(record)
                        results.append((record.recordID, result))
                    }
        return (results, nil)
    }
}
