//
//  DylanApp.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI
import GTLogging
import ComposableArchitecture
import Search
import Core

@main
struct DylanApp: App {
    
    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?
    
    let appStore = Store(initialState: AppState(),
                         reducer: appReducer,
                         environment: AppEnvironment(search: Searcher().search,
                                                     randomSong: Searcher().randomSong,
                                                     randomAlbum: Searcher().randomAlbum,
                                                     randomPerformance: Searcher().randomPerformance,
                                                     cloudKitClient: .live))
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: appStore)
                .onAppear {
                    ViewStore(appStore).send(.cloudKit(.start(date: lastFetchDate)))
                }
        }
    }
}
