//
//  AppReducer.swift
//
//
//  Created by Henry Cooper on 05/08/2022.
//

import Foundation

import ComposableArchitecture
import Search
import CasePaths
import BottomBar
import GTCloudKit
import Add
import Model
import AllPerformances

struct AppEnvironment {
    let search: (Search) -> Effect<AnyModel?, Never>
    let randomSong: () -> Effect<SongDisplayModel?, Never>
    let randomAlbum: () -> Effect<AlbumDisplayModel?, Never>
    let randomPerformance: () -> Effect<PerformanceDisplayModel?, Never>
    let cloudKitClient: CloudKitClient
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
Reducer.combine(searchReducer.pullback(
    state: \.search,
    action: /AppAction.search,
    environment: SearchEnvironment.init),
                bottomBarFeatureReducer.pullback(
                    state: \.bottomBarState,
                    action: /AppAction.bottomBar,
                    environment: BottomBarEnvironment.init),
                addReducer.pullback(
                    state: \.addState,
                    action: /AppAction.add,
                    environment: { _ in () }),
                allPerformancesFeatureReducer.pullback(
                    state: \.allPerformancesState,
                    action: /AppAction.allPerformances,
                    environment: SearchEnvironment.init),
                cloudKitReducer.pullback(
                    state: \.cloudKitState,
                    action: /AppAction.cloudKit,
                    environment: CloudKitEnvironment.init)
)

extension SearchEnvironment {
    
    init(appEnvironment: AppEnvironment) {
        self.init(search: appEnvironment.search,
                  randomSong: appEnvironment.randomSong,
                  randomAlbum: appEnvironment.randomAlbum,
                  randomPerformance: appEnvironment.randomPerformance)
    }
}

extension BottomBarEnvironment {
    init(appEnvironment: AppEnvironment) {
        let search = SearchEnvironment(appEnvironment: appEnvironment)
        self.init(search: search)
    }
}

extension CloudKitEnvironment {
    init(appEnvironment: AppEnvironment) {
        self.init(client: appEnvironment.cloudKitClient)
    }
}
