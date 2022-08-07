//
//  GTFormatter.swift
//  GTFormatter
//
//  Created by Henry Cooper on 07/08/2022.
//

import Foundation

public class Formatter {

    private lazy var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.timeZone = .init(identifier: "GMT")
        return formatter
    }()
    
    public init() {}

    public func dateString(of double: Double?) -> String {
        guard let double = double else {
            return "Unknown date"
        }
        let date = Date(timeIntervalSince1970: double)
        return dateFormatter.string(from: date)
    }

    public func date(from string: String) -> Double? {
        return dateFormatter.date(from: string)?.timeIntervalSince1970
    }

}
