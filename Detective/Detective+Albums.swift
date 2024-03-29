//
//  Detective+Albums.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
import CoreData
import OSLog
import Combine
import GTCoreData
import Model
import ComposableArchitecture

extension Detective {
    
    func fetchAlbumModel(for id: NSManagedObjectID) -> Effect<AnyModel?, Never> {
        let context = container.newBackgroundContext()
        return .future { callback in
            context.perform { [self] in
                guard let object = context.object(with: id) as? Album,
                      let songs = object.songs?.array as? [Song] else {
                    return callback(.success(nil))
                }
                let model = createAlbumDisplayModel(from: object, with: songs)
                callback(.success(AnyModel(model)))
            }
        }
    }
    
    func fetchAlbumModel(for string: String) -> Effect<AnyModel?, Never> {
        let context = container.newBackgroundContext()
        return .future { completion in
            // Fetch album with given title
            let titlePredicate = NSPredicate(format: "title =[c] %@", string)
            let uuidPrediate = NSPredicate(format: "uuid =[c] %@", string)
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, uuidPrediate])
            context.performFetch(Album.self, with: predicate) { [self] albums in
                guard let first = albums.first,
                      let songs = first.songs?.array as? [Song] else {
                    return completion(.success(nil))
                }
                let model = createAlbumDisplayModel(from: first, with: songs)
                completion(.success(AnyModel(model)))
            }
        }
    }
    
    private func createAlbumDisplayModel(from album: Album, with songs: [Song]) -> AlbumDisplayModel {
        let sSongs = songs.compactMap { sSong(uuid: $0.uuid!,
                                              title: $0.title!,
                                              author: $0.songAuthor,
                                              isFavorite: $0.isFavorite,
                                              baseSongUUID: $0.baseSongUUID) }
        let sAlbum = sAlbum(uuid: album.uuid!,
                            title: album.title!,
                            songs: sSongs,
                            releaseDate: album.releaseDate,
                            isFavorite: album.isFavorite)
        return AlbumDisplayModel(album: sAlbum)

    }

}

public extension Detective {
    
    func randomAlbum() -> Effect<AlbumDisplayModel?, Never> {
        let context = container.newBackgroundContext()
        return .future { completion in
            context.performFetch(Album.self) { [self] albums in
                guard let random = albums.randomElement(),
                      let songs = random.songs?.array as? [Song] else {
                    return completion(.success(nil))
                }
                let model = createAlbumDisplayModel(from: random, with: songs)
                completion(.success(model))
            }
        }
    }
}
