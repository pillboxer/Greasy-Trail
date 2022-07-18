//
//  CloudKitManager+Albums.swift
//  Dylan
//
//  Created by Henry Cooper on 27/06/2022.
//

import CloudKit
import CoreData
import OSLog

extension CloudKitManager {
    
    func fetchLatestAlbums() async throws {
        
        os_log("Fetching latest albums", Log_CloudKit)
        let records = try await fetchRecords(of: .album)
        os_log("Found %@ albums", log: Log_CloudKit, String(describing: records.count))
        
        // Store titles and release dates
        let titles = records.compactMap { $0.string(for: .title) }
        let releaseDates = records.map { $0.double(for: .releaseDate) }
        
        for (index, record) in records.enumerated() {
            
            // Get the title and release date of the album
            let title = titles[index]
            let releaseDate = releaseDates[index]
            if let metadata = record.data(for: .metadata) {
                print(metadata)
            }
            await setCurrentStep(to: .albums(title))
            
            let ordered = try await getOrderedSongRecords(from: record)
            let context = container.newBackgroundContext()
            // Get the Song objects
            let songTitles = ordered.compactMap { $0.string(for: .title) }
            let correspondingSongs: [Song] = songTitles.compactMap { title in
                let predicate = NSPredicate(format: "title == %@", title)
                return context.fetchAndWait(Song.self, with: predicate).first
            }

            await context.perform {
                // Check for existing album
                let predicate = NSPredicate(format: "title == %@", title)
                let existingAlbum = context.fetchAndWait(Album.self, with: predicate).first
                // Create or update album
                let album = existingAlbum ?? Album(context: context)
                album.title = title
                album.releaseDate = releaseDate ?? -1
                album.uuid = record.recordID.recordName
                // Add the songs to the Album
                let orderedSet = NSOrderedSet(array: correspondingSongs)
                album.songs = orderedSet
                try? context.save()
            }
        }
    }
}
