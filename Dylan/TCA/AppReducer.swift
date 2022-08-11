//
//  AppReducer.swift
//  TableSelection
//
//  Created by Henry Cooper on 05/08/2022.
//

import Foundation

import ComposableArchitecture
import Search
import TableList

let appReducer: (inout AppState, AppAction) -> Void =
logging(combine(
    pullback(tableListReducer, value: \.tableListState, action: \.tableListAction),
    pullback(searchReducer, value: \.searchState, action: \.searchAction)))
