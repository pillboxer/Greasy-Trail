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
    
    // Should throw
    func fetch(song title: String) async -> SongDisplayModel? {
        
        os_log("Fetching song with title: %@", log: Log_CloudKit, title)
        
        // Fetch The Song
        let predicate = NSPredicate(format: "title == %@", title)
        let query = CKQuery(recordType: .song, predicate: predicate)
        
        /// FIXME
        let records = try! await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        os_log("Found %@ records matching", String(describing: records.count))
        guard let firstResult = records.first?.1 else {
            return nil
        }
        
        switch firstResult {
        case .success(let record):
            
            guard let songTitle = record.string(for: .title) else {
                return nil
            }
            let asReference = CKRecord.Reference(recordID: record.recordID, action: .none)
            let albums = try! await albumsThatIncludeSong(asReference)
            // Fetch The Albums it appeared on
            
            let newSong = Song(title: songTitle, firstLivePerformance: nil, albums: albums)
            return SongDisplayModel(song: newSong)
        default:
            return nil
        }
    }
    
    func fetch(from recordIDs: [CKRecord.ID], of type: DylanRecordType) async throws -> [RecordType]? {
        let query = CKQuery(recordType: type)
        let records = try? await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        let results = records?.map { $0.1 }
        let albums = results?.compactMap { try? $0.get() }
        return albums
    }
    
}



