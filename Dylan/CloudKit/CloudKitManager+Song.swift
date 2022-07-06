//
//  CloudKitManager+Song.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import CloudKit
import OSLog

extension CloudKitManager {
    
    func fetch(song title: String) async throws -> SongDisplayModel? {
        
        let records = try await fetch(with: title, recordType: .song)
        
        guard let firstResult = records.first?.1,
              case .success(let record) = firstResult,
              let title = record.string(for: .title) else {
            return nil
        }
        
        let asReference = CKRecord.Reference(recordID: record.recordID, action: .none)
        let albums = try await albumsThatInclude(song: asReference)
        let performances = try await performancesThatInclude(song: asReference)
        
        let newSong = Song(title: title, performances: performances, albums: albums)
        return SongDisplayModel(song: newSong)
        
    }

    
}
