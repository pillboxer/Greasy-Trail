//
//  AllPerformances+Reducer.swift
//  AllPerformances
//
//  Created by Henry Cooper on 11/09/2022.
//

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
        state.selectedPerformanceDecade = decade
        return .none
    }
}
