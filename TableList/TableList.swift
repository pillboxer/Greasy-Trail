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

public let tableListReducer = combine(
    pullback(tableSelectionReducer, value: \TableListState.ids, action: \TableListAction.tableSelect),
    pullback(searchReducer, value: \TableListState.searchState, action: \TableListAction.search))

public class TableListState {
    
    public var ids: Set<ObjectIdentifier> = []
    public var model: Model?
    public var failedSearch: Search?
    public var currentSearch: Search?
    
    public init(ids: Set<ObjectIdentifier>, model: Model?, failedSearch: Search?) {
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
    
    var tableSelect: TableSelectionAction? {
        get {
            guard case let .tableSelect(value) = self else { return nil }
            return value
        }
        set {
            guard case .tableSelect = self, let newValue = newValue else { return }
            self = .tableSelect(newValue)
        }
    }
    
    var search: SearchAction? {
        get {
            guard case let .search(value) = self else { return nil }
            return value
        }
        set {
            guard case .search = self, let newValue = newValue else { return }
            self = .search(newValue)
        }
    }
    
}
