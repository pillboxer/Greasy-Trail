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
import ComposableArchitecture

extension Detective {
    
    func fetch(performance date: Double) -> Effect<AnyModel?> {
        let context = container.newBackgroundContext()
        
        return .async { completion in
            context.perform { [self] in
                let predicate = NSPredicate(format: "date == %d", Int(date))
                guard let performance = context.fetchAndWait(Performance.self, with: predicate).first,
                      let songs = performance.songs?.array as? [Song] else {
                    return completion(nil)
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
                completion(AnyModel(PerformanceDisplayModel(sPerformance: sPerformance)))
            }
        }
    }
    
    // For when we move to async
    private func _performancesThatInclude(song: Song) async -> [sPerformance] {
        await withCheckedContinuation { continuation in
            fetchPerformancesThatInclude(song: song) { performances in
                continuation.resume(returning: performances)
            }
        }
    }
    
    func fetchPerformancesThatInclude(song: Song, completion: @escaping ([sPerformance]) -> Void) {
        let context = container.newBackgroundContext()
        let objectID = song.objectID
        context.perform { [weak self] in
            self?.objects(Performance.self, including: song, context: context) { objects in
                if let song = context.object(with: objectID) as? Song {
                    os_log("%{public}@ found on %{public}@ performances(s)",
                           song.title!,
                           String(describing: objects.count))
                    let sPerformances = objects.compactMap { sPerformance(uuid: $0.uuid!,
                                                                          venue: $0.venue!,
                                                                          songs: [],
                                                                          date: $0.date) }
                    let sorted = sPerformances.sorted { $0.date ?? -1 < $1.date ?? -1 }
                    completion(sorted)
                } else {
                    completion([])
                }
            }
        }
    }
}
