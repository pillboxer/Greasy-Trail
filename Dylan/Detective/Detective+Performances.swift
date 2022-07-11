//
//  Detective+Performances.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import OSLog
import CoreData

extension Detective {

    func fetch(performance date: Double) -> PerformanceDisplayModel? {
        let context = container.newBackgroundContext()
        var toReturn: PerformanceDisplayModel?
        context.performAndWait {
            // Fetch album with given title
            let predicate = NSPredicate(format: "date == %d", Int(date))
            guard let performance = context.fetchAndWait(Performance.self, with: predicate).first else {
                toReturn = nil
                return
            }
            // Get the songs
            let songs = performance.songs?.array as? [Song] ?? []
            let sSongs = songs.compactMap { sSong(title: $0.title!, author: $0.author) }
            let sPerformance = sPerformance(venue: performance.venue!,
                                            songs: sSongs,
                                            date: performance.date,
                                            lbNumbers: performance.lbNumbers)
            toReturn = PerformanceDisplayModel(sPerformance: sPerformance)
        }
        return toReturn
    }

    func performancesThatInclude(song: Song) -> [sPerformance] {
        let context = container.newBackgroundContext()
        var toReturn: [sPerformance] = []
        let objects = objects(Performance.self, including: song, context: context)
        context.performAndWait {
            os_log("%@ found on %@ performances(s)", song.title!, String(describing: objects.count))
            let sPerformances = objects.compactMap { sPerformance(venue: $0.venue!, songs:[], date: $0.date) }
            toReturn = sPerformances.sorted { $0.date ?? -1 < $1.date ?? -1 }
        }
        return toReturn
    }
    
}

