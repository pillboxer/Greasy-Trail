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
        formatter.timeZone = .init(identifier: "GMT")
        return formatter
    }()

    func dateString(of double: Double?) -> String {
        guard let double = double else {
            return "Unknown date"
        }
        let date = Date(timeIntervalSince1970: double)
        return dateFormatter.string(from: date)
    }

    func date(from string: String) -> Double? {
        return dateFormatter.date(from: string)?.timeIntervalSince1970
    }

    func formatted(performance: sPerformance) -> String {
        let prefix = performance.venue
        var suffix = "Unknown date"
        if let date = performance.date {
            suffix = dateString(of: date)
        }
        return "\(prefix) (\(suffix))"
    }

}
