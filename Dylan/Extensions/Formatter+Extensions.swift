//
//  Formatter+Extensions.swift
//  GTFormatter
//
//  Created by Henry Cooper on 07/08/2022.
//

import Foundation
import GTFormatter
import Model

extension GTFormatter.Formatter {
    
    func formatted(performance: sPerformance) -> String {
        let prefix = performance.venue
        var suffix = "Unknown date"
        if let date = performance.date {
            suffix = dateString(of: date)
        }
        return "\(prefix) (\(suffix))"
    }
     
}
