//
//  AppReducer.swift
//  TableSelection
//
//  Created by Henry Cooper on 05/08/2022.
//

import Foundation

import ComposableArchitecture
import Search
import CasePaths
import Add

struct AppEnvironment {
    let searchEnvironment: SearchEnvironment
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
combine(pullback(searchReducer,
             value: \.searchState,
             action: /AppAction.search,
             environment: { $0.searchEnvironment }),
    pullback(addReducer,
             value: \.addState,
             action: /AppAction.add,
             environment: { _ in () }))
