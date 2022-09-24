import Foundation

import ComposableArchitecture
import Search
import CasePaths
import BottomBar
import Result
import GTCloudKit
import Add
import Model
import TopBar
import AllPerformances
import AllSongs
import Stats

struct AppEnvironment {
    let search: (Search) -> Effect<AnyModel?, Never>
    let randomSong: () -> Effect<SongDisplayModel?, Never>
    let randomAlbum: () -> Effect<AlbumDisplayModel?, Never>
    let randomPerformance: () -> Effect<PerformanceDisplayModel?, Never>
    let cloudKitClient: CloudKitClient
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
Reducer.combine(
    searchReducer.pullback(
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
    topBarFeatureReducer.pullback(
        state: \.topBarState,
        action: /AppAction.topBar,
        environment: CloudKitEnvironment.init),
    statsFeatureReducer.pullback(
        state: \.statsState,
        action: /AppAction.stats,
        environment: SearchEnvironment.init),
    cloudKitReducer.pullback(
        state: \.cloudKitState,
        action: /AppAction.cloudKit,
        environment: CloudKitEnvironment.init),
    commandMenuReducer.pullback(
        state: \.commandMenuState,
        action: /AppAction.commandMenu,
        environment: { _ in () }),
    allSongsFeatureReducer.pullback(
        state: \.allSongsState,
        action: /AppAction.allSongs,
        environment: SearchEnvironment.init)
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
        let cloudKit = CloudKitEnvironment(appEnvironment: appEnvironment)
        self.init(search: search, cloudKit: cloudKit)
    }
}

extension CloudKitEnvironment {
    init(appEnvironment: AppEnvironment) {
        self.init(client: appEnvironment.cloudKitClient)
    }
}
