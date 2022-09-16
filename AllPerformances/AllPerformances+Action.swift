import Search
import CoreData

public enum AllPerformancesFeatureAction {
    case allPerformances(AllPerformancesAction)
    case search(SearchAction)
}

public enum AllPerformancesAction {
    case selectDecade(PerformanceDecade)
}

enum AllPerformancesViewAction {
    case search(Search)
    case select(objectIdentifier: ObjectIdentifier?, id: NSManagedObjectID?)
    case selectPerformanceDecade(PerformanceDecade)
}

extension AllPerformancesFeatureAction {
    init(_ action: AllPerformancesViewAction) {
        switch action {
        case .search(let search):
            self = .search(.makeSearch(search))
        case .select(let objectIdentifier, let id):
            self = .search(.select(objectIdentifier: objectIdentifier, objectID: id))
        case .selectPerformanceDecade(let performanceDecade):
            self = .allPerformances(.selectDecade(performanceDecade))
        }
    }
}
