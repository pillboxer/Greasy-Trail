public enum PerformanceDateFormat: String, CustomStringConvertible, CaseIterable, Decodable {
    case full = "MMMM d, yyyy"
    case monthAndYear = "MMMM yyyy"
    case unknownMonth = "yyyy"
    
    public var description: String {
        switch self {
        case .full:
            return "Day, month, year "
        case .monthAndYear:
           return "Month and year"
        case .unknownMonth:
            return "Year only"
        }
    }
}
