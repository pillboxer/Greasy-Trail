import GTCoreData
import GTFormatter

extension CloudKitClient {
    
    static func fetchSongsLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateFetchProgress(of: .song, to: 0))
                    let records = try await fetchRecords(of: .song, after: date)
                    let titles = records.map { $0.string(for: .title) }
                    let authors = records.map { $0.string(for: .author) }
                    let baseSongUUIDs = records.map { $0.string(for: .baseSongUUID) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateFetchProgress(of: .song, to: Double(index) / Double(records.count)))
                        await context.perform {
                            let title = titles[index] ?? "Unknown Title"
                            let author = authors[index]
                            let baseSongUUID = baseSongUUIDs[index]
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let song: Song
                            if let existingSong = context.fetchAndWait(Song.self, with: predicate).first {
                                song = existingSong
                            } else {
                                song = Song(context: context)
                            }
                            song.baseSongUUID = baseSongUUID
                            song.title = title
                            song.author = author
                            song.uuid = record.recordID.recordName
                        }
                        await context.asyncSave()
                    }
                    continuation.yield(.updateFetchProgress(of: .song, to: 1))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    static func fetchPerformancesLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateFetchProgress(of: .performance, to: 0))
                    let records = try await fetchRecords(of: .performance, after: date)
                    let venues = records.compactMap { $0.string(for: .venue) }
                    let dates = records.compactMap { $0.double(for: .date)?.rounded() }
                    let dateFormats = records.map { $0.string(for: .dateFormat) }
                    let lbNumbers = records.map { $0.ints(for: .lbNumbers) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateFetchProgress(
                            of: .performance,
                            to: Double(index) / Double(records.count)))
                        let venue = venues[index]
                        let date = dates[index]
                        let lbs = lbNumbers[index]
                        let dateFormat = dateFormats[index]
                        let ordered = try await getOrderedSongRecords(from: record)
                        let songIDs = ordered.compactMap { $0.recordID.recordName }
                        let correspondingSongs: [Song] = songIDs.compactMap { id in
                            let predicate = NSPredicate(format: "uuid == %@", id)
                            return context.fetchAndWait(Song.self, with: predicate).first
                        }
                        await context.perform {
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let existingPerformance = context.fetchAndWait(Performance.self, with: predicate).first
                            let performance = existingPerformance ?? Performance(context: context)
                            performance.venue = venue
                            performance.date = date
                            performance.lbNumbers = lbs
                            performance.dateFormatString = dateFormat
                            performance.uuid = record.recordID.recordName
                            let orderedSet = NSOrderedSet(array: correspondingSongs)
                            performance.songs = orderedSet
                        }
                        await context.asyncSave()
                    }
                    continuation.yield(.updateFetchProgress(of: .performance, to: 1))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    static func fetchAlbumsLive(after date: Date?) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateFetchProgress(of: .album, to: 0))
                    let records = try await fetchRecords(of: .album, after: date)
                    let titles = records.compactMap { $0.string(for: .title) }
                    let releaseDates = records.map { $0.double(for: .releaseDate) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateFetchProgress(of: .album, to: Double(index) / Double(records.count)))
                        let title = titles[index]
                        let releaseDate = releaseDates[index]
                        let ordered = try await getOrderedSongRecords(from: record)
                        let songIDs = ordered.compactMap { $0.recordID.recordName }
                        let correspondingSongs: [Song] = songIDs.compactMap { id in
                            let predicate = NSPredicate(format: "uuid == %@", id)
                            return context.fetchAndWait(Song.self, with: predicate).first
                        }
                        await context.perform {
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let existingAlbum = context.fetchAndWait(Album.self, with: predicate).first
                            let album = existingAlbum ?? Album(context: context)
                            album.title = title
                            album.releaseDate = releaseDate ?? -1
                            album.uuid = record.recordID.recordName
                            let orderedSet = NSOrderedSet(array: correspondingSongs)
                            album.songs = orderedSet
                        }
                        await context.asyncSave()
                    }
                    continuation.yield(.updateFetchProgress(of: .album, to: 1))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
