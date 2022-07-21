//
//  Detective+Albums.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
import CoreData
import OSLog

extension Detective {

    func fetch(album title: String) -> AlbumDisplayModel? {
        let context = container.newBackgroundContext()
        var toReturn: AlbumDisplayModel?
        context.performAndWait {
            // Fetch album with given title
            let predicate = NSPredicate(format: "title =[c] %@", title)
            guard let album = context.fetchAndWait(Album.self, with: predicate).first,
                  let songs = album.songs?.array as? [Song] else {
                toReturn = nil
                return
            }
            // Get the songs
            let sSongs = songs.compactMap { sSong(title: $0.title!, author: $0.songAuthor) }
            let sAlbum = sAlbum(title: album.title!, songs: sSongs, releaseDate: album.releaseDate)
            toReturn = AlbumDisplayModel(album: sAlbum)
        }
        return toReturn
    }

    func albumsThatInclude(song objectID: NSManagedObjectID) -> [sAlbum] {
        let context = container.newBackgroundContext()
        var toReturn: [sAlbum] = []
        context.performAndWait {
            if let song = context.object(with: objectID) as? Song {
                let objects = objects(Album.self, including: song, context: context)
                os_log("%@ found on %@ album(s)", song.title!, String(describing: objects.count))
                let sAlbums = objects.compactMap { sAlbum(title: $0.title!, songs: [], releaseDate: $0.releaseDate) }
                toReturn = sAlbums.sorted { $0.releaseDate < $1.releaseDate }
            }
        }
        return toReturn
    }

}
