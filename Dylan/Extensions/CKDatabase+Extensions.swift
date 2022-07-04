//
//  CKDatabase+Extensions.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

extension CKDatabase: DatabaseType {
    
    func recordTypes(for ids: [CKRecord.ID], desiredKeys: [CKRecord.FieldKey]?) async throws -> [CKRecord.ID : Result<RecordType, Error>] {
        let oldReturn = try await records(for: ids, desiredKeys: desiredKeys)
        var toReturn: [CKRecord.ID : Result<RecordType, Error>] = [:]
        for pair in oldReturn {
            let id = pair.key
            let result = pair.value.map { $0 as RecordType }
            toReturn[id] = result
        }
        return toReturn
    }
    
    
    func recordTypes(matching query: CKQuery, inZoneWith zoneID: CKRecordZone.ID? = nil, desiredKeys: [CKRecord.FieldKey]? = nil, resultsLimit: Int = CKQueryOperation.maximumResults) async throws -> (matchResults: [(CKRecord.ID, Result<RecordType, Error>)], queryCursor: CKQueryOperation.Cursor?) {
        let oldReturn = try await self.records(matching: query, inZoneWith: zoneID, desiredKeys: desiredKeys, resultsLimit: resultsLimit)
        let oldResults = oldReturn.matchResults
        var new: [(CKRecord.ID, Result<RecordType, Error>)] = []
        for result in oldResults {
            let newSuccess = result.1.map { $0 as RecordType }
            new.append((result.0, newSuccess))
        }
        
        return (new, oldReturn.queryCursor)
    }
    
}
