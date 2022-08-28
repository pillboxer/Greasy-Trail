//
//  AppAction.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 03/08/2022.
//

import Search
import Add
import BottomBar

enum AppAction {
    case search(SearchAction)
    case add(AddAction)
    case bottomBar(BottomBarFeatureAction)
}
