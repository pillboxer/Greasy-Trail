//
//  CloudKitManager+Performances.swift
//  Dylan
//
//  Created by Henry Cooper on 05/07/2022.
//

import Foundation
import CloudKit

extension CloudKitManager {
    
    func performancesThatInclude(song songReferenceToMatch: CKRecord.Reference) async throws -> [Performance] {
        var performances: [Performance] = []
        let predicate = NSPredicate(format: "songs CONTAINS %@", songReferenceToMatch)
        let query = CKQuery(recordType: .performance, predicate: predicate)
        let results = try await database.referenceRecordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        let recordTypes = results.compactMap { try? $0.1.get() }
        let venues = recordTypes.compactMap { $0.string(for: .venue) }
        let dates = recordTypes.compactMap { $0.double(for: .date)}
        for (index, _) in recordTypes.enumerated() {
            let venue = venues[index]
            let date = dates[index]
            let performance = Performance(venue: venue, songs: nil, date: date)
            performances.append(performance)
        }
        return performances.sorted { $0.date ?? 0 < $1.date ?? 0 }
        
    }
    
}
