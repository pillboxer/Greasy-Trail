//
//  Detective+Songs.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
import OSLog
import CoreData
import GTCoreData
import GTLogging
import Model
import Combine
import ComposableArchitecture

struct Misspellings: Codable {
    var songs: [String: String]
}

extension Detective {

    public func uuid(for song: String) -> String? {
        let songObject: NSManagedObject?
        songObject = fetch(song: song) ?? fetch(song: resolveSpellingOf(song: song))
        guard let song = songObject else {
            os_log("Could not find song %{public}@", log: Log_Detective, song)
            return nil
        }
        var id: String?
        let context = container.newBackgroundContext()
        return context.syncPerform {
            let objectID = song.objectID
            let song = context.object(with: objectID) as? Song
            id = song?.uuid
            return id
        }
    }
    
    func randomSong() -> Effect<SongDisplayModel?, Never> {
        let context = container.newBackgroundContext()
        return .future { completion in
            context.performFetch(Song.self) { songs in
                guard let random = songs.randomElement() else {
                    return completion(.success(nil))
                }
                self.createSongDisplayModel(from: random) { model in
                    return completion(.success(model))
                }
            }
        }
    }
    
    public func fetchModel(for title: String) -> Effect<AnyModel?, Never> {
        let context = container.newBackgroundContext()
        
        return .future { completion in
            context.perform { [self] in
                guard let song = fetch(song: title) ?? fetch(song: resolveSpellingOf(song: title)) else {
                    return completion(.success(nil))
                }
                let id = song.objectID
                if let song = context.object(with: id) as? Song {
                    createSongDisplayModel(from: song) { songDisplayModel in
                        completion(.success(AnyModel(songDisplayModel)))
                    }
                } else {
                    return completion(.success(nil))
                }
            }
        }
    }
    
    private func createSongDisplayModel(from song: Song, completion: @escaping (SongDisplayModel) -> Void) {
        let uuid = song.uuid!
        let title = song.title!
        let author = song.songAuthor
        fetchPerformancesThatInclude(song: song) { performances in
            let sSong = sSong(uuid: uuid,
                              title: title,
                              author: author,
                              performances: performances)
            completion(SongDisplayModel(song: sSong))
        }
    }
}

private extension Detective {
    
    func fetch(song title: String) -> Song? {
        let context = container.newBackgroundContext()
        let regexPredicate = NSPredicate(format: "title =[c] %@", title)
        let titleBeforeParentheses = title.before(first: "(").trimmingCharacters(in: .whitespaces)
        let matchPredicate = NSPredicate(format: "title =[c] %@", titleBeforeParentheses)
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [regexPredicate, matchPredicate])
        let song = context.fetchAndWait(Song.self, with: predicate).first
        return song
    }
    
    func resolveSpellingOf(song: String) -> String {
        let context = container.newBackgroundContext()
        os_log("Attempting to resolve %{public}@", log: Log_Detective, song)

        return context.syncPerform {
            guard let metadata = context.fetchAndWait(AppMetadata.self, with: .misspellings).first,
                  let data = metadata.file,
                  let decoded = try? data.decoded() as Misspellings else {
                os_log("Could not find misspellings data", log: Log_Detective, type: .error)
                return song
            }
            let songsDict = decoded.songs
            let correctlySpelt = songsDict[caseInsensitive: song]
            if let correctlySpelt = correctlySpelt {
                os_log("Resolved to %{public}@", log: Log_Detective, correctlySpelt)
                return correctlySpelt
            } else {
                os_log("Unable to resolve %{public}@", log: Log_Detective, song)
                return song
            }
        }
    }
    
}

private extension String {
    func before(first delimiter: Character) -> String {
          if let index = firstIndex(of: delimiter) {
              let before = prefix(upTo: index)
              return String(before)
          }
          return ""
      }
}

extension Detective {
    
    func fetchSongModel(for id: NSManagedObjectID) -> Effect<AnyModel?, Never> {
        let context = container.newBackgroundContext()
        return .future { callback in
            context.perform { [self] in
                guard let object = context.object(with: id) as? Song else {
                    return callback(.success(nil))
                }
                createSongDisplayModel(from: object) { displayModel in
                    callback(.success(AnyModel(displayModel)))
                }
            }

        }
    }
}

extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
