//
//  CloudKitClient.swift
//  GTCloudKit
//
//  Created by Henry Cooper on 13/09/2022.
//

import GTCoreData

public struct CloudKitEnvironment {
    var client: CloudKitClient
    
    public init(client: CloudKitClient) {
        self.client = client
    }
}

public struct GTError: Swift.Error, Equatable {
   public let error: NSError

   public init(_ error: Swift.Error) {
     self.error = error as NSError
   }
 }

public struct CloudKitClient {
    var fetchSongs: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var fetchAlbums: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var fetchPerformances: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    
    public enum Event: Equatable {
        case updateProgress(Double, DylanRecordType)
        case completeFetch(newValues: Bool)
    }
}

extension CloudKitClient {
    
    public static let live = CloudKitClient(
        fetchSongs: { date in
            fetchSongsLive(after: date)
        }, fetchAlbums: { date in
            fetchAlbumsLive(after: date)
        }, fetchPerformances: { date in
            fetchPerformancesLive(after: date)
        })
    
    private static func fetchSongsLive(after date: Date?) -> AsyncThrowingStream<Event, Swift.Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateProgress(0, .song))
                    let records = try await fetch(.song, after: date)
                    let titles = records.map { $0.string(for: .title) }
                    let authors = records.map { $0.string(for: .author) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateProgress(Double(index) / Double(records.count), .song))
                        await context.perform {
                            let title = titles[index] ?? "Unknown Title"
                            let author = authors[index]
                            let predicate = NSPredicate(format: "title == %@", title)
                            let song: Song
                            if let existingSong = context.fetchAndWait(Song.self, with: predicate).first {
                                song = existingSong
                            } else {
                                song = Song(context: context)
                            }
                            song.title = title
                            song.author = author
                            song.uuid = record.recordID.recordName
                        }
                        await context.asyncSave()
                    }
                    continuation.yield(.updateProgress(1, .song))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private static func fetchPerformancesLive(after date: Date?) -> AsyncThrowingStream<Event, Swift.Error> {
        .init { continuation in
            Task {
                do {
                    continuation.yield(.updateProgress(0, .performance))
                    let records = try await fetch(.performance, after: date)
                    let venues = records.compactMap { $0.string(for: .venue) }
                    let dates = records.compactMap { $0.double(for: .date) }
                    let lbNumbers = records.map { $0.ints(for: .lbNumbers) }
                    let context = PersistenceController.shared.newBackgroundContext()
                    
                    for (index, record) in records.enumerated() {
                        continuation.yield(.updateProgress(Double(index) / Double(records.count), .performance))
                        let venue = venues[index]
                        let date = dates[index]
                        let lbs = lbNumbers[index]
                        let ordered = try await getOrderedSongRecords(from: record)
                        let songTitles = ordered.compactMap { $0.string(for: .title) }
                        let correspondingSongs: [Song] = songTitles.compactMap { title in
                            let predicate = NSPredicate(format: "title == %@", title)
                            return context.fetchAndWait(Song.self, with: predicate).first
                        }
                        await context.perform {
                            let predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
                            let existingPerformance = context.fetchAndWait(Performance.self, with: predicate).first
                            let performance = existingPerformance ?? Performance(context: context)
                            performance.venue = venue
                            performance.date = date
                            performance.lbNumbers = lbs
                            performance.uuid = record.recordID.recordName
                            let orderedSet = NSOrderedSet(array: correspondingSongs)
                            performance.songs = orderedSet
                        }
                        await context.asyncSave()
                    }
                    continuation.yield(.updateProgress(1, .album))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private static func fetchAlbumsLive(after date: Date?) -> AsyncThrowingStream<Event, Swift.Error> {
        .init { continuation in
            Task {
                do {
                continuation.yield(.updateProgress(0, .song))
                let records = try await fetch(.album, after: date)
                let titles = records.compactMap { $0.string(for: .title) }
                let releaseDates = records.map { $0.double(for: .releaseDate) }
                let context = PersistenceController.shared.newBackgroundContext()
                
                for (index, record) in records.enumerated() {
                    continuation.yield(.updateProgress(Double(index) / Double(records.count), .album))
                    let title = titles[index]
                    let releaseDate = releaseDates[index]
                    let ordered = try await getOrderedSongRecords(from: record)
                    let songTitles = ordered.compactMap { $0.string(for: .title) }
                    let correspondingSongs: [Song] = songTitles.compactMap { title in
                        let predicate = NSPredicate(format: "title == %@", title)
                        return context.fetchAndWait(Song.self, with: predicate).first
                    }
                    await context.perform {
                        let predicate = NSPredicate(format: "title == %@", title)
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
                    continuation.yield(.updateProgress(1, .performance))
                    continuation.yield(.completeFetch(newValues: !records.isEmpty))
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

public enum Mode: Equatable {
    case downloaded
    case downloading(progress: Double, DylanRecordType)
    case notDownloaded
    case downloadFailed(GTError)
}
