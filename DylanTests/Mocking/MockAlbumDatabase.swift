//
//  MockAlbumDatabase.swift
//  DylanTests
//
//  Created by Henry Cooper on 05/07/2022.
//

@testable import Dylan
import Foundation
import CloudKit

class MockAlbumDatabase {
    
    private let albumRecord: MockAlbumRecord
    private let songRecords: [MockSongRecord]
    
    init(albumRecord: MockAlbumRecord, songRecords: [MockSongRecord]) {
        self.albumRecord = albumRecord
        self.songRecords = songRecords
    }
    
}

extension MockAlbumDatabase: DatabaseType {
    
    func referenceRecordTypes(matching query: CKQuery, inZoneWith zoneID: CKRecordZone.ID?, desiredKeys: [CKRecord.FieldKey]?, resultsLimit: Int) async throws -> (matchResults: [(CKRecord.ID, Result<RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?) {
        ([], nil)
    }
    
    func recordTypes(matching query: CKQuery, inZoneWith zoneID: CKRecordZone.ID?, desiredKeys: [CKRecord.FieldKey]?, resultsLimit: Int) async throws -> (matchResults: [(CKRecord.ID,
                                                                                                                                                                          Result<RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?) {
        var results: [(CKRecord.ID, Result<Dylan.RecordType, Error>)] = []
        let result = Result<RecordType, Error>.success(albumRecord)
        results.append((albumRecord.recordID, result))
        return (results, nil)
    }
    
    func recordTypes(for ids: [CKRecord.ID], desiredKeys: [CKRecord.FieldKey]?) async throws -> [CKRecord.ID : Result<RecordType, Error>] {
        var toReturn: [CKRecord.ID : Result<RecordType, Error>] = [:]
        for (index, id) in ids.enumerated() {
            toReturn[id] = Result.success(songRecords[index])
        }
        return toReturn
    }
    
}
