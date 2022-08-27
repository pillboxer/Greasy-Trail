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

public struct TableListState: Equatable {
    
    public var ids: Set<ObjectIdentifier> = []
    public var model: Model?
    public var failedSearch: Search?
    public var currentSearch: Search?
    
    public init(ids: Set<ObjectIdentifier>, model: Model?, failedSearch: Search?) {
        self.ids = ids
        self.model = model
        self.failedSearch = failedSearch
    }
    
    public static func == (lhs: TableListState, rhs: TableListState) -> Bool {
        guard lhs.model?.uuid == rhs.model?.uuid else {
            return false
        }
        let lhsTuple = (lhs.ids, lhs.failedSearch, lhs.currentSearch)
        let rhsTuple = (rhs.ids, rhs.failedSearch, rhs.currentSearch)
        return (lhsTuple) == (rhsTuple)
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
