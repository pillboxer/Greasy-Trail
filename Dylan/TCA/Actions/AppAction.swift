//
//  AppAction.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 03/08/2022.
//

import TableList
import Search
import Add

enum AppAction {
    case tableList(TableListAction)
    case search(SearchAction)
    case add(AddAction)
}
