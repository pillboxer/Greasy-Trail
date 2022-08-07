//
//  ResultView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI
import ComposableArchitecture

/// Coordinates between different result views
struct ResultView: View {
    
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @EnvironmentObject private var store: Store<AppState, AppAction>
    
    var body: some View {
        if store.value.songDisplayModel != nil {
            ResultSongOverviewView()
        } else if store.value.albumDisplayModel != nil {
            ResultAlbumOverviewView()
        } else if let model = store.value.performanceDisplayModel {
            ResultPerformanceOverviewView(model: model,
                                          editorViewModel: EditorViewModel(editable: model.sPerformance))
        }
    }
}
