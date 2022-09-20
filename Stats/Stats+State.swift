import Core
import Search

public struct StatsState: Equatable {
    public var displayedView: DisplayedView
    public var isFetchingMissingLBCount: Bool
    public var missingLBNumbers: [Int]?
    public var search: SearchState
    
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
