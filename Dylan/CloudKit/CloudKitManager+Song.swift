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
        
        os_log("Fetching latest songs", Log_CloudKit)
        let predicate = NSPredicate(format: "modificationDate > %@", (lastFetchDate ?? .distantPast) as NSDate)
        let query = CKQuery(recordType: .song, predicate: predicate)
        
        let array = await database.fetchPagedResults(with: query)
        let records = array.compactMap { try? $0.1.get() }
        let titles = records.map { $0.string(for: .title) }
        let authors = records.map { $0.string(for: .author) }
        
        os_log("%@ songs fetched", log: Log_CloudKit, String(describing: records.count))
        let context = container.newBackgroundContext()
        for (index, _) in records.enumerated() {
            let title = titles[index]
            let author = authors[index]
            await context.perform {
                let predicate = NSPredicate(format: "title == %@", title ?? "")
                let existingSong = context.fetchAndWait(Song.self, with: predicate).first
                let song = existingSong ?? Song(context: context)
                song.title = title
                song.author = author
                try? context.save()
            }
        }
    }
    
    func getOrderedSongRecords(from record: RecordType) async throws -> [RecordType] {
        let songReferences = record.references(of: .songs)
        let ids = songReferences.compactMap { $0.recordID }
        
        // Fetch the records
        let dict = try await database.recordTypes(for: ids, desiredKeys: nil)
        var ordered: [RecordType] = []
        
        // Ensure songs are in the correct order
        for id in ids {
            guard let result = dict[id] else {
                print("** NO RESULT **")
                continue
            }
            guard let recordType = try? result.get() else {
                let album = record.string(for: .title) ?? record.string(for: .venue)
                let badName = id.recordName
                
                print("TITLE: \(album!) || BAD NAME: \(badName)")
                continue
            }
            ordered.append(recordType)
        }
        return ordered
    }

}
