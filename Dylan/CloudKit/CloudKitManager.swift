//
//  CloudKitManager.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    private static let container = CKContainer(identifier: "iCloud.Dylan")
    
    // Should throw
    func fetch(song title: String) async -> SongDisplayModel {
        
        // Fetch The Song
        let predicate = NSPredicate(format: "title == %@", title)
        let query = CKQuery(recordType: .song, predicate: predicate)
        
        
        /// FIXME
        let records = try! await Self.container.publicCloudDatabase.recordTypes(matching: query).matchResults
        guard let firstResult = records.first?.1 else {
            fatalError()
        }
        
        switch firstResult {
        case .success(let record):
            print("record arrived \(record)")
            // Fetch The Albums it appeared on
            let albumReferences = record.references(of: .albums)
            let allAlbumRecordIDs = albumReferences.map { $0.recordID }
            let albums = try! await fetch(from: allAlbumRecordIDs, of: .album)
            print(albums)
        default:
            fatalError("No success")
        }
        return SongDisplayModel(song: Song(title: "Yo"))
    }
    
    private func fetch(from recordIDs: [CKRecord.ID], of type: DylanRecordType) async throws -> [CKRecord] {
        let query = CKQuery(recordType: type)
        let records = try! await Self.container.publicCloudDatabase.records(matching: query).matchResults
        let results = records.map { $0.1 }
        let albums = results.compactMap { try? $0.get() }
        return albums
    }
    
}



