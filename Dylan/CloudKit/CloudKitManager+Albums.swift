//
//  CloudKitManager+Albums.swift
//  Dylan
//
//  Created by Henry Cooper on 27/06/2022.
//

import CloudKit

extension CloudKitManager {
    
    func albumsThatIncludeSong(_ songReferenceToMatch: CKRecord.Reference) async throws -> [Album] {
        var albums: [Album] = []
        let predicate = NSPredicate(format: "songs CONTAINS %@", songReferenceToMatch)
        let query = CKQuery(recordType: .album, predicate: predicate)
        let results = try await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        let recordTypes = results.compactMap { try? $0.1.get() }
        let albumTitles = recordTypes.compactMap { $0.string(for: .title) }
        let albumReleaseDates = recordTypes.compactMap { $0.double(for: .releaseDate)}
        
        for (index, _) in recordTypes.enumerated() {
            let title = albumTitles[index]
            let releaseDate = albumReleaseDates[index]
            let album = Album(title: title, songs: [], releaseDate: releaseDate)
            albums.append(album)
        }
        return albums.sorted { $0.releaseDate < $1.releaseDate }        
    }
}
