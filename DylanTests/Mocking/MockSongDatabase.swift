//
//  MockDatabase.swift
//  DylanTests
//
//  Created by Henry Cooper on 26/06/2022.
//


@testable import Dylan
import CloudKit

class MockSongDatabase: DatabaseType {
    
    var songRecord: MockSongRecord?
    var referenceRecords: [MockAlbumRecord]?
    
    init(_ songRecord: MockSongRecord?) {
        self.songRecord = songRecord
    }
    
    func recordTypes(matching query: CKQuery, inZoneWith zoneID: CKRecordZone.ID?, desiredKeys: [CKRecord.FieldKey]?, resultsLimit: Int) async throws -> (matchResults: [(CKRecord.ID, Result<Dylan.RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?) {
        
        var results: [(CKRecord.ID, Result<Dylan.RecordType, Error>)] = []
        
        if let referenceRecords = referenceRecords {
            for case let record as RecordType in referenceRecords {
                let result = Result<RecordType, Error>.success(record)
                results.append((record.recordID, result))
            }
        }
        else {
            guard let songRecord = songRecord else { return ([], nil) }
            let recordsToAdd = songRecord.references.compactMap { $0.record }
            referenceRecords = recordsToAdd
            let result = Result<RecordType, Error>.success(songRecord)
            results.append((songRecord.recordID, result))
        }
        return (results, nil)
    }
    
}
