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
    
    func fetch(album title: String) -> Effect<AnyModel?> {
        let context = container.newBackgroundContext()
        return .async { completion in
            // Fetch album with given title
            let predicate = NSPredicate(format: "title =[c] %@", title)
            guard let album = context.fetchAndWait(Album.self, with: predicate).first,
                  let songs = album.songs?.array as? [Song] else {
                return completion(nil)
            }
            // Get the songs
            let sSongs = songs.compactMap { sSong(uuid: $0.uuid!, title: $0.title!, author: $0.songAuthor) }
            let sAlbum = sAlbum(uuid: album.uuid!,
                                title: album.title!,
                                songs: sSongs,
                                releaseDate: album.releaseDate)
            completion(AnyModel(AlbumDisplayModel(album: sAlbum)))
        }
    }

    func albumsThatInclude(song objectID: NSManagedObjectID) -> [sAlbum] {
        let context = container.newBackgroundContext()
        return context.syncPerform { 
            if let song = context.object(with: objectID) as? Song {
                let objects = objects(Album.self, including: song, context: context)
                os_log("%{public}@ found on %{public}@ album(s)", song.title!, String(describing: objects.count))
                let sAlbums = objects.compactMap { sAlbum(uuid: $0.uuid!,
                                                          title: $0.title!,
                                                          songs: [],
                                                          releaseDate: $0.releaseDate) }
                return sAlbums.sorted { $0.releaseDate < $1.releaseDate }
            }
            return []
        }
    }

}
