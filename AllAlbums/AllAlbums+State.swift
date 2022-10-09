import Search

public struct AllAlbumsState: Equatable {
    public var search: SearchState
    public var albumPredicate: AlbumPredicate
    public var displaysAdminFunctionality: Bool
    
    public init(search: SearchState, albumPredicate: AlbumPredicate, displaysAdminFunctionality: Bool) {
        self.search = search
        self.albumPredicate = albumPredicate
        self.displaysAdminFunctionality = displaysAdminFunctionality
    }
}

struct AllAlbumsViewState: Equatable {
    var selectedID: ObjectIdentifier?
    var selectedPredicate: AlbumPredicate
    var displaysAdminFunctionality: Bool
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
