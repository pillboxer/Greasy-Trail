//
//  AppAction.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 03/08/2022.
//

import Search
import Add
import BottomBar
import GTCloudKit
import AllPerformances
import TopBar
import Stats

enum AppAction {
    case search(SearchAction)
    case add(AddAction)
    case bottomBar(BottomBarFeatureAction)
    case cloudKit(CloudKitAction)
    case allPerformances(AllPerformancesFeatureAction)
    case topBar(TopBarFeatureAction)
    case stats(StatsAction)
}
