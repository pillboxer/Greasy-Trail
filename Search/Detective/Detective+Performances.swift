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
                context.performFetch(Performance.self, with: predicate) { [self] performances in
                    guard let first = performances.first,
                          let songs = first.songs?.array as? [Song] else {
                        return completion(nil)
                    }
                    let displayModel = createPerformanceDisplayModel(from: first, with: songs)
                    completion(AnyModel(displayModel))
                }
            }
        }
    }
    
    private func createPerformanceDisplayModel(from performance: Performance,
                                               with songs: [Song]) -> PerformanceDisplayModel {
        var sSongs: [sSong] = []
        for song in songs {
            sSongs.append(sSong(uuid: song.uuid!,
                                title: song.title!,
                                author: song.songAuthor))
        }
        let sPerformance = sPerformance(uuid: performance.uuid!,
                                        venue: performance.venue!,
                                        songs: sSongs,
                                        date: performance.date,
                                        lbNumbers: performance.lbNumbers)
        return PerformanceDisplayModel(sPerformance: sPerformance)
        
    }
    
    func randomPerformance() -> Effect<PerformanceDisplayModel?> {
        let context = container.newBackgroundContext()
        return .async { completion in
            context.performFetch(Performance.self) { [self] performances in
                guard let random = performances.randomElement(),
                      let songs = random.songs?.array as? [Song] else {
                     return completion(nil)
                }
                completion(createPerformanceDisplayModel(from: random, with: songs))
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
