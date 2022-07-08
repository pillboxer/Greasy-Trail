//
//  CloudKitManager+Song.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import CloudKit
import OSLog

extension CloudKitManager {
    
    func fetchLatestSongs() async throws {
        
        os_log("Fetching latest songs")
        let predicate = NSPredicate(format: "modificationDate > %@", (lastFetchDate ?? .distantPast) as NSDate)
        let query = CKQuery(recordType: .song, predicate: predicate)
        
        let array = try await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        let records = array.compactMap { try? $0.1.get() }
        let titles = records.map { $0.string(for: .title) }
        let authors = records.map { $0.string(for: .author) }
        
        os_log("%@ songs fetched", String(describing: records.count))
        let context = PersistenceController.shared.newBackgroundContext()
        for (index, _) in records.enumerated() {
            let title = titles[index]
            let author = authors[index]
            await context.perform {
                let song = Song(context: context)
                song.title = title
                song.author = author
                try? context.save()
            }
        }
    }
    
    func fetch(song title: String) throws -> SongDisplayModel? {
        let context = PersistenceController.shared.newBackgroundContext()
        var toReturn: SongDisplayModel?
        let predicate = NSPredicate(format: "title == %@", title)
        guard let song = context.fetchAndWait(Song.self, with: predicate).first else {
            toReturn = nil
            return nil
        }
        let id = song.objectID
        context.performAndWait{
            let albums = albumsThatInclude(song: id)
            let performances = performancesThatInclude(song: song)
            let sSong = sSong(title: song.title!, performances: performances, albums: albums)
            toReturn = SongDisplayModel(song: sSong)
        }
        return toReturn
    }
    
    func getOrderedSongRecords(from record: RecordType) async throws -> [RecordType] {
        let songReferences = record.references(of: .songs)
        let ids = songReferences.compactMap { $0.recordID }
        
        // Fetch the records
        let dict = try await database.recordTypes(for: ids, desiredKeys: nil)
        var ordered: [RecordType] = []
        
        // Ensure songs are in the correct order
        ids.forEach { id in
            if let recordType = try? dict[id]?.get() {
                ordered.append(recordType)
            }
        }
        return ordered
    }

}
