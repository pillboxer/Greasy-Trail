import Core
import Search

public struct StatsState: Equatable {
    public var displayedView: DisplayedView
    public var isFetchingMissingLBCount: Bool
    public var missingLBNumbers: [Int]?
    public var search: SearchState
    
    public var searchState: SearchState {
        get {
            SearchState(model: search.model,
                        displayedView: displayedView,
                        failedSearch: search.failedSearch,
                        currentSearch: search.currentSearch,
                        searchFieldText: search.searchFieldText,
                        selectedID: search.selectedID,
                        selectedObjectID: search.selectedObjectID,
                        isSearching: search.isSearching)
        }
        set {
            self.search = newValue
            self.displayedView = newValue.displayedView
        }
    }
    
    public init(displayedView: DisplayedView,
                isFetchingMissingLBCount: Bool,
                missingLBNumbers: [Int]?,
                search: SearchState) {
        self.displayedView = displayedView
        self.isFetchingMissingLBCount = isFetchingMissingLBCount
        self.missingLBNumbers = missingLBNumbers
        self.search = search
    }
}

public struct StatsViewState: Equatable {
    public var isFetchingMissingLBCount: Bool
}

extension StatsViewState {
    init(_ statsState: StatsState) {
        self.isFetchingMissingLBCount = statsState.isFetchingMissingLBCount
    }
}
