//
//  AppReducer.swift
//  TableSelection
//
//  Created by Henry Cooper on 05/08/2022.
//

import Foundation

import TableSelection
import ComposableArchitecture
import Search

let appReducer: (inout AppState, AppAction) -> Void =
combine(pullback(tableSelectionReducer, value: \.selection, action: \.tableSelect),
        pullback(searchReducer, value: \.model, action: \.search))
