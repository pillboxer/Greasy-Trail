import Search

public struct AllAlbumsState: Equatable {
    public var search: SearchState
    public var albumPredicate: AlbumPredicate
    
    public init(search: SearchState, albumPredicate: AlbumPredicate) {
        self.search = search
        self.albumPredicate = albumPredicate
    }
}

struct AllAlbumsViewState: Equatable {
    var selectedID: ObjectIdentifier?
    var selectedPredicate: AlbumPredicate
}

public enum AlbumPredicate: String, CaseIterable, Equatable {
    case all = "All"
    case favorites = "Favorites"
    
    public var predicate: NSPredicate {
        switch self {
        case .favorites:
            return NSPredicate(format: "isFavorite = true")
        default:
            return NSPredicate(value: true)
        }
    }
}
