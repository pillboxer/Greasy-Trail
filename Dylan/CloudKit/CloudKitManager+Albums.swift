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
        let records = try await  fetchRecords(of: .album)
        os_log("Found %@ albums", String(describing: records.count), Log_CloudKit)
        
        // Store titles and release dates
        let titles = records.compactMap { $0.string(for: .title) }
        let releaseDates = records.map { $0.double(for: .releaseDate) }
        
        for (index, record) in records.enumerated() {
            
            // Get the title and release date of the album
            let title = titles[index]
            let releaseDate = releaseDates[index]
            
            let ordered = try await getOrderedSongRecords(from: record)
            let context = PersistenceController.shared.newBackgroundContext()
            // Get the Song objects
            let songTitles = ordered.compactMap { $0.string(for: .title) }
            let correspondingSongs = songTitles.compactMap { title in
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
                os_log("Adding %@ songs to album", String(describing: correspondingSongs.count), Log_CloudKit)
                // Add the songs to the Album
                let orderedSet = NSOrderedSet(array: correspondingSongs)
                album.songs = orderedSet
                try? context.save()
            }
        }
    }
        
    
    func fetch(album title: String) -> AlbumDisplayModel? {
        let context = PersistenceController.shared.newBackgroundContext()
        var toReturn: AlbumDisplayModel?
        context.performAndWait {
            // Fetch album with given title
            let predicate = NSPredicate(format: "title == %@", title)
            guard let album = context.fetchAndWait(Album.self, with: predicate).first else {
                toReturn = nil
                return
            }
            // Get the songs
            let songs = album.songs?.array as? [Song] ?? []
            let sSongs = songs.compactMap { sSong(title: $0.title!, author: $0.author) }
            let sAlbum = sAlbum(title: album.title!, songs: sSongs, releaseDate: album.releaseDate)
            toReturn = AlbumDisplayModel(album: sAlbum)
        }
        return toReturn
    }
    
    func albumsThatInclude(song objectID: NSManagedObjectID) -> [sAlbum] {
        let context = PersistenceController.shared.newBackgroundContext()
        var toReturn: [sAlbum] = []
        context.performAndWait {
            let song = context.object(with: objectID) as! Song
            let objects = objects(Album.self, including: song, context: context)
            os_log("%@ found on %@ album(s)", song.title!, String(describing: objects.count))
            let sAlbums = objects.compactMap { sAlbum(title: $0.title!, songs:[], releaseDate: $0.releaseDate) }
            toReturn = sAlbums.sorted { $0.releaseDate < $1.releaseDate }
        }
        return toReturn
    }
}
