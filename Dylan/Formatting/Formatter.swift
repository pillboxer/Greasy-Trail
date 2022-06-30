//
//  Formatter.swift
//  Dylan
//
//  Created by Henry Cooper on 30/06/2022.
//

import Combine
import Foundation

class Formatter: ObservableObject {
    
    private lazy var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    func dateString(of double: Double) -> String {
        let date = Date(timeIntervalSince1970: double)
        return dateFormatter.string(from: date)
    }
    
    func formatted(performance: Performance) -> String {
        let prefix = performance.venue
        var suffix = "Unknown date"
        if let date = performance.date {
            suffix = dateString(of: date)
        }
        return "\(prefix) (\(suffix))"
        
    }
    
}
