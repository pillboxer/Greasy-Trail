import Core
import Search

public enum StatsFeatureAction {
    case search(SearchAction)
    case stats(StatsAction)
}

public enum StatsAction {
    case selectDisplayedView(DisplayedView)
    case fetchMissingLBNumbers
    case completeFetch([Int])
}

public enum StatsViewAction {
    case search(Search)
    case fetchMissingLBNumbers
}

extension StatsFeatureAction {
    init(_ action: StatsViewAction) {
        switch action {
        case .search(let search):
            self = .search(.makeSearch(search))
        case .fetchMissingLBNumbers:
            self = .stats(.fetchMissingLBNumbers)
        }
    }
}
