//
//  Detective+Songs.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
import OSLog
import CoreData
import Combine

struct Misspellings: Codable {
    var songs: [String: String]
}

extension Detective {

    func uuid(for song: String) -> String? {
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

    func fetchModel(for title: String) -> AnyPublisher<Model?, Never> {
        let context = container.newBackgroundContext()
        guard let song = fetch(song: title) ?? fetch(song: resolveSpellingOf(song: title)) else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        let id = song.objectID

        return Future { promise in
            context.perform { [self] in
                if let song = context.object(with: id) as? Song {
                    let albums = albumsThatInclude(song: id)
                    let performances = performancesThatInclude(song: song)
                    let sSong = sSong(uuid: song.uuid!,
                        title: song.title!,
                                      author: song.songAuthor,
                                      performances: performances,
                                      albums: albums)
                    promise(.success(SongDisplayModel(song: sSong)))
                }
                promise(.success(nil))
            }
        }.eraseToAnyPublisher()
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
