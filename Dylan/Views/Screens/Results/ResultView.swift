//
//  ResultView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI
import ComposableArchitecture
import ResultPerformance
import ResultSongOverview
import Search
/// Coordinates between different result views
struct ResultView: View {
    
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @EnvironmentObject private var store: Store<AppState, AppAction>
    
    var body: some View {
        if let model = store.value.songDisplayModel {
            ResultSongOverviewView(model: model, store: store.view(value: {
                return SearchState(model: $0.model, failedSearch: $0.failedSearch, currentSearch: $0.currentSearch)
            }, action: {
                .search($0)
            }))
        } else if store.value.albumDisplayModel != nil {
            ResultAlbumOverviewView()
        } else if let model = store.value.performanceDisplayModel {
            ResultPerformanceOverviewView(model: model, store: store.view(value: {
                return SearchState(model: $0.model, failedSearch: $0.failedSearch, currentSearch: $0.currentSearch)
            }, action: {
                return .search($0)
            }))
        }
    }
}
