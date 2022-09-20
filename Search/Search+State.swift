import Model
import Core
import CoreData

public enum DylanSearchType: CaseIterable {
    case song
    case album
    case performance
}

public struct SearchState: Equatable {
    
    public static func == (lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.model == rhs.model
        && lhs.failedSearch == rhs.failedSearch
        && lhs.currentSearch == rhs.currentSearch
    }
    
    public var model: AnyModel?
    public var displayedView: DisplayedView
    public var failedSearch: Search?
    public var currentSearch: Search?
    public var selectedID: ObjectIdentifier?
    public var selectedObjectID: NSManagedObjectID?
    public var isSearching = false
    public var searchFieldText = ""
    
    public init(model: AnyModel?,
                displayedView: DisplayedView,
                failedSearch: Search?,
                currentSearch: Search?,
                searchFieldText: String,
                selectedID: ObjectIdentifier?,
                selectedObjectID: NSManagedObjectID?,
                isSearching: Bool) {
        self.model = model
        self.failedSearch = failedSearch
        self.currentSearch = currentSearch
        self.selectedID = selectedID
        self.searchFieldText = searchFieldText
        self.selectedObjectID = selectedObjectID
        self.isSearching = isSearching
        self.displayedView = displayedView
    }
}

public struct Search: Equatable {
    public var title: String?
    public var type: DylanSearchType?
    public var id: NSManagedObjectID?

    public init(title: String, type: DylanSearchType?) {
        self.title = title
        self.type = type
    }

    public init(id: NSManagedObjectID) {
        self.id = id
    }
}
