//
//  CloudKitManager+Albums.swift
//  Dylan
//
//  Created by Henry Cooper on 27/06/2022.
//

import Foundation

extension CloudKitManager {
    
    func createSongAlbums(from record: RecordType) async -> [Album] {
        var albums: [Album] = []
        
        let albumReferences = record.references(of: .albums)
        let allAlbumRecordIDs = albumReferences.map { $0.recordID }
        
        guard let albumRecords = try? await fetch(from: allAlbumRecordIDs, of: .album) else {
            return albums
        }
        
        let albumTitles = albumRecords.compactMap { $0.string(for: .title) }
        let albumReleaseDates = albumRecords.compactMap { $0.double(for: .releaseDate)}
        
        for (index, _) in albumRecords.enumerated() {
            let title = albumTitles[index]
            let releaseDate = albumReleaseDates[index]
            let album = Album(title: title, songs: [], releaseDate: releaseDate)
            albums.append(album)
        }
        return albums.sorted { $0.releaseDate < $1.releaseDate }
    }
}
