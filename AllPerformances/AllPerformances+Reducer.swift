import Search
import ComposableArchitecture

public let allPerformancesFeatureReducer: Reducer<AllPerformancesState,
                                                    AllPerformancesFeatureAction,
                                                    SearchEnvironment> =
Reducer.combine(searchReducer.pullback(
    state: \.search,
    action: /AllPerformancesFeatureAction.search,
    environment: { $0 }),
                allPerformancesReducer.pullback(
                    state: \.self,
                    action: /AllPerformancesFeatureAction.allPerformances,
                    environment: { _ in () })
)

private let allPerformancesReducer = Reducer<AllPerformancesState, AllPerformancesAction, Void> { state, action, _ in
    switch action {
    case .selectDecade(let decade):
        logger.log("Selected decade \(decade.rawValue, privacy: .public)")
        state.selectedPerformancePredicate = decade
        return .none
    }
}
