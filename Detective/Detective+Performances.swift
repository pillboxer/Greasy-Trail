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

public extension Detective {
    
    func fetch(performance date: Double) -> Effect<AnyModel?, Never> {
        let context = container.newBackgroundContext()
        
        return .future { completion in
            context.perform {
                let predicate = NSPredicate(format: "date == %d", Int(date))
                context.performFetch(Performance.self, with: predicate) { [self] performances in
                    guard let first = performances.first,
                          let songs = first.songs?.array as? [Song] else {
                        return completion(.success(nil))
                    }
                    let displayModel = createPerformanceDisplayModel(from: first, with: songs)
                    completion(.success(AnyModel(displayModel)))
                }
            }
        }
    }
    
    func randomPerformance() -> Effect<PerformanceDisplayModel?, Never> {
        let context = container.newBackgroundContext()
        return .future { completion in
            context.performFetch(Performance.self) { [self] performances in
                guard let random = performances.randomElement(),
                      let songs = random.songs?.array as? [Song] else {
                    return completion(.success(nil))
                }
                completion(.success(createPerformanceDisplayModel(from: random, with: songs)))
            }
        }
    }
}

extension Detective {
    
    func fetchPerformanceModel(for id: NSManagedObjectID) -> Effect<AnyModel?, Never> {
        let context = container.newBackgroundContext()
        return .future { callback in
            context.perform {
                guard let object = context.object(with: id) as? Performance,
                      let songs = object.songs?.array as? [Song] else {
                    return callback(.success(nil))
                }
                let displayModel = self.createPerformanceDisplayModel(from: object, with: songs)
                callback(.success(AnyModel(displayModel)))
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
                                                                          date: $0.date,
                                                                          isFavorite: $0.isFavorite) }
                    let sorted = sPerformances.sorted { $0.date < $1.date }
                    completion(sorted)
                } else {
                    completion([])
                }
            }
        }
    }
}

private extension Detective {
    
    func createPerformanceDisplayModel(from performance: Performance,
                                       with songs: [Song]) -> PerformanceDisplayModel {
        var sSongs: [sSong] = []
        for song in songs {
            sSongs.append(sSong(uuid: song.uuid!,
                                title: song.title!,
                                author: song.songAuthor,
                                isFavorite: song.isFavorite))
        }
        let sPerformance = sPerformance(uuid: performance.uuid!,
                                        venue: performance.venue!,
                                        songs: sSongs,
                                        date: performance.date,
                                        lbNumbers: performance.lbNumbers ?? [],
                                        isFavorite: performance.isFavorite)
        return PerformanceDisplayModel(sPerformance: sPerformance)
        
    }
    
}
