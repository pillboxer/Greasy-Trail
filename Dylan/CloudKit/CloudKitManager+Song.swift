//
//  CloudKitManager+Song.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import CloudKit
import OSLog

extension CloudKitManager {
    
    // Should throw
    func fetch(song title: String) async -> SongDisplayModel? {
        
        os_log("Fetching song with title: %@", log: Log_CloudKit, title)
        
        // Fetch The Song
        let predicate = NSPredicate(format: "title == %@", title)
        let query = CKQuery(recordType: .song, predicate: predicate)
        
        /// FIXME
        
        let records = try! await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        os_log("Found %@ records matching", log: Log_CloudKit, String(describing: records.count))
        
        guard let firstResult = records.first?.1,
              case .success(let record) = firstResult,
              let title = record.string(for: .title) else {
            return nil
        }
        
        let asReference = CKRecord.Reference(recordID: record.recordID, action: .none)
        let albums = try! await albumsThatIncludeSong(asReference)
        // Fetch The Albums it appeared on
        
        let newSong = Song(title: title, firstLivePerformance: nil, albums: albums)
        return SongDisplayModel(song: newSong)
        
    }
        
    
}
