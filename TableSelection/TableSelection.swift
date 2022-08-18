//
//  TableSelection.swift
//  TableSelection
//
//  Created by Henry Cooper on 05/08/2022.
//

import Foundation
import ComposableArchitecture

public enum TableSelectionAction {
    case select(identifier: ObjectIdentifier)
}

public func tableSelectionReducer(state: inout Set<ObjectIdentifier>,
                                  action: TableSelectionAction) -> [Effect<TableSelectionAction>] {
    switch action {
    case .select(let identifier):
        state.removeAll()
        state.insert(identifier)
        return []
    }
}
