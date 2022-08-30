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
    let search: (Search) -> Effect<AnyModel?>
    let randomSong: () -> Effect<SongDisplayModel?>
    let randomAlbum: () -> Effect<AlbumDisplayModel?>
    let randomPerformance: () -> Effect<PerformanceDisplayModel?>
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
Reducer.combine(searchReducer.pullback(
                 value: \.searchState,
                 action: /AppAction.search,
                 environment: SearchEnvironment.init),
        bottomBarFeatureReducer.pullback(
                 value: \.bottomBarState,
                 action: /AppAction.bottomBar,
                 environment: SearchEnvironment.init),
        addReducer.pullback(
                 value: \.addState,
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
