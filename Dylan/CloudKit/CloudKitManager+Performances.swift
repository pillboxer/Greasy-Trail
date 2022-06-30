//
//  CloudKitManager+Performances.swift
//  Dylan
//
//  Created by Henry Cooper on 30/06/2022.
//

import Foundation

extension CloudKitManager {
    
    func createSongFirstPerformance(from record: RecordType) async -> Performance? {
        let performanceReference = record.reference(of: .firstLivePerformance)
        let id = performanceReference?.recordID
        
        guard let id = id,
              let record = try? await fetch(from: [id], of: .performance)?.first,
              let venue = record.string(for: .venue) else {
            return nil
        }
        let date = record.double(for: .date)
        
        return Performance(venue: venue, songs: [], date: date)
    }
}
