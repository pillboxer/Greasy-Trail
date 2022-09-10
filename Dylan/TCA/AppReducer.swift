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
import Add
import Model

struct AppEnvironment {
    let search: (Search) -> Effect<AnyModel?, Never>
    let randomSong: () -> Effect<SongDisplayModel?, Never>
    let randomAlbum: () -> Effect<AlbumDisplayModel?, Never>
    let randomPerformance: () -> Effect<PerformanceDisplayModel?, Never>
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
Reducer.combine(searchReducer.pullback(
                 state: \.searchState,
                 action: /AppAction.search,
                 environment: SearchEnvironment.init),
        bottomBarFeatureReducer.pullback(
            state: \.bottomBarState,
                 action: /AppAction.bottomBar,
                 environment: SearchEnvironment.init),
        addReducer.pullback(
            state: \.addState,
                 action: /AppAction.add,
                 environment: { _ in () }))

extension SearchEnvironment {
    
    init(appEnvironment: AppEnvironment) {
        self.init(search: appEnvironment.search,
                  randomSong: appEnvironment.randomSong,
                  randomAlbum: appEnvironment.randomAlbum,
                  randomPerformance: appEnvironment.randomPerformance)
    }
    
}
