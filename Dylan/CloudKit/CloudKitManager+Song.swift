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
        
        let records = try await fetch(.song, after: Self.lastFetchDateSongs)
        let titles = records.map { $0.string(for: .title) }
        let authors = records.map { $0.string(for: .author) }

        let context = container.newBackgroundContext()
        
        for (index, record) in records.enumerated() {
            
            await setProgress(to: Double(index) / Double(records.count))
            await setCurrentStep(to: .fetching(.song))
            
            context.syncPerform {
                let title = titles[index] ?? "Unknown Title"
                let author = authors[index]
                let predicate = NSPredicate(format: "title == %@", title)
                let song: Song
                if let existingSong = context.fetchAndWait(Song.self, with: predicate).first {
                    os_log("Existing song found, updating %@", log: Log_CloudKit, title)
                    song = existingSong
                } else {
                    os_log("Creating new song %@", log: Log_CloudKit, title)
                    song = Song(context: context)
                }
                song.title = title
                song.author = author
                song.uuid = record.recordID.recordName
                context.saveWithTry()
            }
        }
        Self.lastFetchDateSongs = Date()
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
                os_log("ID was not found in song references. Continuing", log: Log_CloudKit, type: .error)
                continue
            }
            guard let recordType = try? result.get() else {
                let title = record.string(for: .title) ?? record.string(for: .venue) ?? ""
                let badName = id.recordName
                os_log("Unknown ID %@ found in song records of %@", log: Log_CloudKit, type: .error, badName, title)
                continue
            }
            ordered.append(recordType)
        }
        return ordered
    }

}
