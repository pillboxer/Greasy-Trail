//
//  TableList.swift
//  TableList
//
//  Created by Henry Cooper on 11/08/2022.
//

import ComposableArchitecture
import TableSelection
import Search
import Model
import CasePaths

public let tableListReducer: Reducer<TableListState, TableListAction, SearchEnvironment> = combine(
    pullback(tableSelectionReducer,
             value: \TableListState.ids,
             action: /TableListAction.tableSelect,
             environment: { _ in () }),
    pullback(searchReducer,
             value: \TableListState.searchState,
             action: /TableListAction.search,
             environment: { $0 }))

public struct TableListState {
    
    public var ids: Set<ObjectIdentifier> = []
    public var model: AnyModel?
    public var failedSearch: Search?
    public var currentSearch: Search?
    
    public init(ids: Set<ObjectIdentifier>, model: AnyModel?, failedSearch: Search?) {
        self.ids = ids
        self.model = model
        self.failedSearch = failedSearch
    }
}

extension TableListState {
    
    var searchState: SearchState {
        get {
            SearchState(model: model, failedSearch: failedSearch, currentSearch: currentSearch)
        }
        set {
            self.failedSearch = newValue.failedSearch
            self.model = newValue.model
            self.currentSearch = newValue.currentSearch
        }
    }
    
}

public enum TableListAction {
    case tableSelect(TableSelectionAction)
    case search(SearchAction)
}
