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
    
    func fetch(album title: String) -> Effect<AnyModel?, Never> {
        let context = container.newBackgroundContext()
        return .future { completion in
            // Fetch album with given title
            let predicate = NSPredicate(format: "title =[c] %@", title)
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

    private func createAlbumDisplayModel(from album: Album, with songs: [Song]) -> AlbumDisplayModel {
        let sSongs = songs.compactMap { sSong(uuid: $0.uuid!, title: $0.title!, author: $0.songAuthor) }
        let sAlbum = sAlbum(uuid: album.uuid!,
                            title: album.title!,
                            songs: sSongs,
                            releaseDate: album.releaseDate)
        return AlbumDisplayModel(album: sAlbum)

    }

}
