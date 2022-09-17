public enum DisplayedView: Equatable {
    case home
    case add(DylanWork)
    case songs
    case albums
    case performances
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
