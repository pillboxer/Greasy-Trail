//
//  AppAction.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 03/08/2022.
//

import TableSelection
import Search

enum AppAction {
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
