import Foundation
import Core

public class Formatter {

    private lazy var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.timeZone = .init(identifier: "GMT")
        return formatter
    }()
    
    public init() {}

    public func dateString(of double: Double?, in format: PerformanceDateFormat) -> String {
        guard let double = double else {
            return "Unknown date"
        }
        dateFormatter.dateFormat = format.rawValue
        let date = Date(timeIntervalSince1970: double)
        return dateFormatter.string(from: date)
    }

    public func date(from string: String) -> Double? {
        let formats = ["MMMM d YYYY",
                       "d MMMM YYYY",
                       "MM/dd/yyyy",
                       "dd/MM/yyyy"]
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: string)?.timeIntervalSince1970 {
                return date
            }
        }
        return nil
    }

}
