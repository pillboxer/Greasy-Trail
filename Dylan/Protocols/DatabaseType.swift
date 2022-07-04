//
//  DatabaseType.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

protocol DatabaseType {
    
    func recordTypes(matching query: CKQuery,
                     inZoneWith zoneID: CKRecordZone.ID?,
                     desiredKeys: [CKRecord.FieldKey]?,
                     resultsLimit: Int) async throws -> (matchResults: [(CKRecord.ID, Result<RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?)
    func referenceRecordTypes(matching query: CKQuery,
                              inZoneWith zoneID: CKRecordZone.ID?,
                              desiredKeys: [CKRecord.FieldKey]?,
                              resultsLimit: Int) async throws -> (matchResults: [(CKRecord.ID, Result<RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?)
    func recordTypes(for ids: [CKRecord.ID],desiredKeys: [CKRecord.FieldKey]?) async throws -> [CKRecord.ID : Result<RecordType, Error>]
}

extension DatabaseType {
    
    func referenceRecordTypes(matching query: CKQuery,
                              inZoneWith zoneID: CKRecordZone.ID?,
                              desiredKeys: [CKRecord.FieldKey]?,
                              resultsLimit: Int) async throws -> (matchResults: [(CKRecord.ID, Result<RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?) {
        try await recordTypes(matching: query, inZoneWith: zoneID, desiredKeys: desiredKeys, resultsLimit: resultsLimit)
    }
    
}
