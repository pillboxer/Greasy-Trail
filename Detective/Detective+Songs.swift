import Foundation
import CoreData
import GTCoreData
import Model
import Combine
import ComposableArchitecture

struct Misspellings: Codable {
    var songs: [String: String]
}

public extension Detective {
    
    func uuid(for song: String) -> String? {
        logger.log("Fetching uuid for \(song, privacy: .public)")
        let songObject: NSManagedObject?
        songObject = fetch(song: song) ?? fetch(song: resolveSpellingOf(song: song))
        guard let song = songObject else {
            logger.log("Could not find song \(song, privacy: .public)")
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
    
    func fetchSongModel(for query: String) -> Effect<AnyModel?, Never> {
        let context = container.newBackgroundContext()
        
        return .future { completion in
            context.perform { [self] in
                guard let song = fetch(song: query) ?? fetch(song: resolveSpellingOf(song: query)) else {
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
    
    func randomSong() -> Effect<SongDisplayModel?, Never> {
        logger.log("Fetching random song")
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

private extension Detective {
    
    func fetch(song query: String) -> Song? {
        logger.log("Fetching song with query \(query, privacy: .public)")
        let context = container.newBackgroundContext()
        let titlePredicate = NSPredicate(format: "title =[c] %@", query)
        let baseSongUUIDPredicate = NSPredicate(format: "uuid = %@", query)
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [baseSongUUIDPredicate, titlePredicate])
        let song = context.fetchAndWait(Song.self, with: predicate).first
        return song
    }
    
    func resolveSpellingOf(song: String) -> String {
        let context = container.newBackgroundContext()
        logger.log("Attempting to resolve \(song, privacy: .public)")

        return context.syncPerform {
            guard let metadata = context.fetchAndWait(AppMetadata.self, with: .misspellings).first,
                  let data = metadata.file,
                  let decoded = try? data.decoded() as Misspellings else {
                logger.log(level: .error, "Could not find misspellings data")
                return song
            }
            let songsDict = decoded.songs
            let correctlySpelt = songsDict[caseInsensitive: song]
            if let correctlySpelt = correctlySpelt {
                logger.log("Resolved to \(correctlySpelt, privacy: .public)")
                return correctlySpelt
            } else {
                logger.log("Unable to resolve \(song, privacy: .public)")
                return song
            }
        }
    }
    
    func createSongDisplayModel(from song: Song, completion: @escaping (SongDisplayModel) -> Void) {
        let uuid = song.uuid!
        let title = song.title!
        let author = song.songAuthor
        let isFavorite = song.isFavorite
        let baseSongUUID = song.baseSongUUID
        fetchPerformancesThatInclude(song: song) { performances in
            let sSong = sSong(uuid: uuid,
                              title: title,
                              author: author,
                              performances: performances,
                              isFavorite: isFavorite,
                              baseSongUUID: baseSongUUID)
            completion(SongDisplayModel(song: sSong))
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

extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
