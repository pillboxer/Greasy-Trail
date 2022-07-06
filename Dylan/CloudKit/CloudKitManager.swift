//
//  CloudKitManager.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import Foundation
import CloudKit
import OSLog

class CloudKitManager {
    
    let database: DatabaseType
    
    init(_ database: DatabaseType) {
        self.database = database
    }
    
    func fetch(with title: String, recordType: DylanRecordType) async throws -> [(CKRecord.ID, Result<RecordType, Error>)] {
        os_log("Fetching %@ with title: %@", log: Log_CloudKit, recordType.rawValue.lowercased(), title)
        
        let predicate = NSPredicate(format: "title == %@", title)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        let records = try await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        
        os_log("Found %@ records matching", log: Log_CloudKit, String(describing: records.count))
        return records
    }
    
    func fetch(with date: Double, recordType: DylanRecordType) async throws ->  [(CKRecord.ID, Result<RecordType, Error>)] {
        os_log("Fetching %@ with date: %@", log: Log_CloudKit, recordType.rawValue.lowercased(), String(date))
        
        let predicate = NSPredicate(format: "date == %d", Int(date))
        let query = CKQuery(recordType: recordType, predicate: predicate)
       
        let records = try await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        
        os_log("Found %@ records matching", log: Log_CloudKit, String(describing: records.count))
        return records
    }
    
}



