//
//  Detective+Performances.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import OSLog
import CoreData

extension Detective {

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

