//
//  CloudKitManager+Albums.swift
//  Dylan
//
//  Created by Henry Cooper on 27/06/2022.
//

import CloudKit
import CoreData
import OSLog
import GTCoreData

extension CloudKitManager {

    func fetchLatestAlbums() async throws {
        let records = try await fetch(.album, after: Self.lastFetchDateAlbums)
        let titles = records.compactMap { $0.string(for: .title) }
        let releaseDates = records.map { $0.double(for: .releaseDate) }
        let context = container.newBackgroundContext()

        for (index, record) in records.enumerated() {
            
            await setProgress(to: Double(index) / Double(records.count))
            await setCurrentStep(to: .fetching(.performance))
            
            let title = titles[index]
            let releaseDate = releaseDates[index]
            let ordered = try await getOrderedSongRecords(from: record)
            
            let songTitles = ordered.compactMap { $0.string(for: .title) }
            let correspondingSongs: [Song] = songTitles.compactMap { title in
                let predicate = NSPredicate(format: "title == %@", title)
                return context.fetchAndWait(Song.self, with: predicate).first
            }

            context.syncPerform {
                let predicate = NSPredicate(format: "title == %@", title)
                let existingAlbum = context.fetchAndWait(Album.self, with: predicate).first
                let album = existingAlbum ?? Album(context: context)
                album.title = title
                album.releaseDate = releaseDate ?? -1
                album.uuid = record.recordID.recordName
                let orderedSet = NSOrderedSet(array: correspondingSongs)
                album.songs = orderedSet
            }
        }
        if !records.isEmpty {
            Self.lastFetchDateAlbums = Date()
        }
        context.performSave()
    }
}
