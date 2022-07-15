//
//  CloudKitManager+Performances.swift
//  Dylan
//
//  Created by Henry Cooper on 05/07/2022.
//

import Foundation
import CloudKit
import OSLog
import CoreData

extension CloudKitManager {
    
    func fetchLatestPerformances() async throws {
        
        os_log("Fetching latest performances", Log_CloudKit)
        let records = try await fetchRecords(of: .performance)
        os_log("Found %@ performances", log: Log_CloudKit, String(describing: records.count))
        
        // Store titles and release dates
        let venues = records.compactMap { $0.string(for: .venue) }
        let dates = records.compactMap { $0.double(for: .date) }
        let lbNumbers = records.map { $0.ints(for: .lbNumbers) }
        
        for (index, record) in records.enumerated() {
            
            // Get the title and release date of the album
            let venue = venues[index]
            let date = dates[index]
            let lbs = lbNumbers[index]
            
            // Fetch the records
            let ordered = try await getOrderedSongRecords(from: record)
            // Get the Song objects
            let songTitles = ordered.compactMap { $0.string(for: .title) }
            let context = container.newBackgroundContext()
            let correspondingSongs = songTitles.compactMap { title in
                let predicate = NSPredicate(format: "title == %@", title)
                return context.fetchAndWait(Song.self, with: predicate).first
            }
            
            await context.perform {
                // Check for existing performance
                let predicate = NSPredicate(format: "date == %d", date)
                let existingPerformance = context.fetchAndWait(Performance.self, with: predicate).first
                // Create or update performance
                let performance = existingPerformance ?? Performance(context: context)
                performance.venue = venue
                performance.date = date
                performance.lbNumbers = lbs
                // Add the songs to the Album
                let orderedSet = NSOrderedSet(array: correspondingSongs)
                performance.songs = orderedSet
                try? context.save()
            }
        }
    }
}
