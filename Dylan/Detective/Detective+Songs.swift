//
//  Detective+Songs.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation

extension Detective {
    
    func fetch(song title: String) -> SongDisplayModel? {
        let context = container.newBackgroundContext()
        var toReturn: SongDisplayModel?
        let predicate = NSPredicate(format: "title == %@", title)
        guard let song = context.fetchAndWait(Song.self, with: predicate).first else {
            toReturn = nil
            return nil
        }
        let id = song.objectID
        context.performAndWait{
            let albums = albumsThatInclude(song: id)
            let performances = performancesThatInclude(song: song)
            let sSong = sSong(title: song.title!, performances: performances, albums: albums)
            toReturn = SongDisplayModel(song: sSong)
        }
        return toReturn
    }
    
}
