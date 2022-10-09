import CoreData
import Search

public struct AllSongsState: Equatable {
    public var search: SearchState
    public var selectedSongPredicate: SongPredicate
    public var displaysAdminFunctionality: Bool
    
    public init(search: SearchState, selectedSongPredicate: SongPredicate, displaysAdminFunctionality: Bool) {
        self.search = search
        self.selectedSongPredicate = selectedSongPredicate
        self.displaysAdminFunctionality = displaysAdminFunctionality
    }
    
    public var selectedID: ObjectIdentifier? {
        search.selectedID
    }
}

public enum SongPredicate: String, CaseIterable, Equatable {
    case all = "All"
    case favorites = "Favorites"
    
    public var predicate: NSPredicate {
        switch self {
        case .favorites:
            return NSPredicate(format: "isFavorite = true")
        default:
            return NSPredicate(format: "baseSongUUID = nil")
        }
    }
}
