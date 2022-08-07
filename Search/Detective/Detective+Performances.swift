//
//  Detective+Performances.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import OSLog
import CoreData
import Combine
import GTCoreData
import Model

extension Detective {
    
    func fetch(performance date: Double) -> Model? {
        let context = container.newBackgroundContext()
        
            return context.syncPerform { [self] in 
                let predicate = NSPredicate(format: "date == %d", Int(date))
                guard let performance = context.fetchAndWait(Performance.self, with: predicate).first,
                      let songs = performance.songs?.array as? [Song] else {
                    return nil
                }
                var sSongs: [sSong] = []
                for song in songs {
                    let id = song.objectID
                    let albums = albumsThatInclude(song: id)
                    sSongs.append(sSong(uuid: song.uuid!,
                                        title: song.title!,
                                        author: song.songAuthor,
                                        albums: albums))
                }
                
                let sPerformance = sPerformance(uuid: performance.uuid!,
                                                venue: performance.venue!,
                                                songs: sSongs,
                                                date: performance.date,
                                                lbNumbers: performance.lbNumbers)
                return PerformanceDisplayModel(sPerformance: sPerformance)
            }
    }
    
    func performancesThatInclude(song: Song) -> [sPerformance] {
        let context = container.newBackgroundContext()
        let objects = objects(Performance.self, including: song, context: context)
        let objectID = song.objectID
        return context.syncPerform {
            if let song = context.object(with: objectID) as? Song {
                os_log("%{public}@ found on %{public}@ performances(s)", song.title!, String(describing: objects.count))
                let sPerformances = objects.compactMap { sPerformance(uuid: $0.uuid!,
                                                                      venue: $0.venue!,
                                                                      songs: [],
                                                                      date: $0.date) }
                return sPerformances.sorted { $0.date ?? -1 < $1.date ?? -1 }
            }
            return []
        }
    }

}
