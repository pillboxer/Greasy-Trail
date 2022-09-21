public enum DisplayedView: Equatable {
    case home
    case add(DylanWork)
    case songs
    case albums
    case performances
    case missingLBs
    case result
    
    public var isAdding: Bool {
        switch self {
        case .add:
            return true
        default:
            return false
        }
    }
}

public extension DisplayedView {
    
    init?(rawValue: String) {
        switch rawValue {
        case "home":
            self = .home
        case "add_songs":
            self = .add(.songs)
        case "add_albums":
            self = .add(.albums)
        case "add_performances":
            self = .add(.performances)
        case "songs":
            self = .songs
        case "albums":
            self = .albums
        case "performances":
            self = .performances
        case "missingLBs":
            self = .missingLBs
        case "result":
            self = .result
        default:
            return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .home:
            return "home"
        case .add(let dylanWork):
            switch dylanWork {
            case .songs:
                return "add_songs"
            case .albums:
                return "add_albums"
            case .performances:
                return "add_performances"
            }
        case .songs:
            return "songs"
        case .albums:
            return "albums"
        case .performances:
            return "performances"
        case .missingLBs:
            return "missingLBs"
        case .result:
            return "result"
        }
    }
    
}
