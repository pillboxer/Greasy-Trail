import Search
import CoreData

public enum AllPerformancesFeatureAction {
    case allPerformances(AllPerformancesAction)
    case search(SearchAction)
}

public enum AllPerformancesAction {
    case selectDecade(PerformancePredicate)
}

enum AllPerformancesViewAction {
    case search(Search)
    case select(objectIdentifier: ObjectIdentifier?, id: NSManagedObjectID?)
    case selectPerformancePredicate(PerformancePredicate)
}

extension AllPerformancesFeatureAction {
    init(_ action: AllPerformancesViewAction) {
        switch action {
        case .search(let search):
            self = .search(.makeSearch(search))
        case .select(let objectIdentifier, let id):
            self = .search(.select(objectIdentifier: objectIdentifier, objectID: id))
        case .selectPerformancePredicate(let PerformancePredicate):
            self = .allPerformances(.selectDecade(PerformancePredicate))
        }
    }
}
