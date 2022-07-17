//
//  Detective+Songs.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
import OSLog

extension Detective {
    
    func uuid(for song: String) -> String? {
        guard let song = fetch(song: song) else {
            os_log("Could not find song %@", log: Log_Detective, song)
            return nil
        }
        var id: String?
        let context = container.newBackgroundContext()
        context.performAndWait {
            let objectID = song.objectID
            let song = context.object(with: objectID) as! Song
            id = song.uuid
        }
        return id
    }
    
    private func fetch(song title: String) -> Song? {
        let context = container.newBackgroundContext()
        let predicate = NSPredicate(format: "title =[c] %@", title)
        guard let song = context.fetchAndWait(Song.self, with: predicate).first else {
            return nil
        }
        return song
    }
    
    func fetchModel(for title: String) -> SongDisplayModel? {
        let context = container.newBackgroundContext()
        var toReturn: SongDisplayModel?
        guard let song = fetch(song: title) else {
            return nil
        }
        let id = song.objectID
        context.performAndWait{
            let song = context.object(with: id) as! Song
            let albums = albumsThatInclude(song: id)
            let performances = performancesThatInclude(song: song)
            let sSong = sSong(title: song.title!, author: song.songAuthor, performances: performances, albums: albums)
            toReturn = SongDisplayModel(song: sSong)
        }
        return toReturn
    }
    
}
