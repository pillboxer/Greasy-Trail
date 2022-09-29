import CoreData
import Search

public struct AllSongsState: Equatable {
    public var search: SearchState
    public var selectedSongPredicate: SongPredicate
    
    public init(search: SearchState, selectedSongPredicate: SongPredicate) {
        self.search = search
        self.selectedSongPredicate = selectedSongPredicate
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
