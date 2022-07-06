//
//  CloudKitManager+Albums.swift
//  Dylan
//
//  Created by Henry Cooper on 27/06/2022.
//

import CloudKit
import OSLog

extension CloudKitManager {
    
    func fetch(album title: String) async throws -> AlbumDisplayModel? {
        let records = try await fetch(with: title, recordType: .album)
        
        guard let firstResult = records.first?.1,
              case .success(let record) = firstResult,
              let title = record.string(for: .title) else {
            return nil
        }
        // FIXME:
        let releaseDate = record.double(for: .releaseDate) ?? -1
        
        let songReferences = record.references(of: .songs)
        let ids = songReferences.compactMap { $0.recordID }
        
        let dict = try await database.recordTypes(for: ids, desiredKeys: nil)
        var ordered: [RecordType] = []
        ids.forEach { id in
            if let recordType = try? dict[id]?.get() {
                ordered.append(recordType)
            }
        }
        let songTitles = ordered.compactMap { $0.string(for: .title) }
        let songs = songTitles.compactMap { Song(title: $0) }
        let album = Album(title: title, songs: songs, releaseDate: releaseDate)
        let model = AlbumDisplayModel(album: album)
        return model
    }
    
    func albumsThatInclude(song songReferenceToMatch: CKRecord.Reference) async throws -> [Album] {
        var albums: [Album] = []
        let predicate = NSPredicate(format: "songs CONTAINS %@", songReferenceToMatch)
        let query = CKQuery(recordType: .album, predicate: predicate)
        let results = try await database.referenceRecordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
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
