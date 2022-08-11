//
//  AppAction.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 03/08/2022.
//

import TableList
import Search

enum AppAction {
    case tableList(TableListAction)
    case search(SearchAction)
    
    var tableListAction: TableListAction? {
      get {
        guard case let .tableList(value) = self else { return nil }
        return value
      }
      set {
        guard case .tableList = self, let newValue = newValue else { return }
        self = .tableList(newValue)
      }
    }
    
    var searchAction: SearchAction? {
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
