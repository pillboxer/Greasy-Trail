//
//  CloudKitManager.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    private let database: DatabaseType
    
    init(_ database: DatabaseType) {
        self.database = database
    }
    
    // Should throw
    func fetch(song title: String) async -> SongDisplayModel? {
        
        // Fetch The Song
        let predicate = NSPredicate(format: "title == %@", title)
        let query = CKQuery(recordType: .song, predicate: predicate)
                
        /// FIXME
        let records = try! await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
       
        guard let firstResult = records.first?.1 else {
            fatalError()
        }
        
        switch firstResult {
        case .success(let record):
            
            let songTitle = record.string(for: .title)
            print("The song's title is \(songTitle)")
            
            // Fetch The Albums it appeared on            
            let albumReferences = record.references(of: .albums)
            let allAlbumRecordIDs = albumReferences.map { $0.recordID }
            
            // FIXME: No force unwrap
            let albumRecords = try! await fetch(from: allAlbumRecordIDs, of: .album)
            let albumTitles = albumRecords.compactMap { $0.string(for:.title) }
            // FIXME: What to do about songs?
            let albums = albumTitles.compactMap { Album(title: $0, songs: [], releaseDate: -9) }
            print("The album titles are \(albumTitles)")
            let newSong = Song(title: songTitle, albums: albums)
            return SongDisplayModel(song: newSong)
        default:
            fatalError("No success")
        }
        
    }
    
    private func fetch(from recordIDs: [CKRecord.ID], of type: DylanRecordType) async throws -> [RecordType] {
        let query = CKQuery(recordType: type)
        let records = try! await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        let results = records.map { $0.1 }
        let albums = results.compactMap { try? $0.get() }
        return albums
    }
    
}



