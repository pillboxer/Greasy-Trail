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
import Model
import Search

/// Coordinates between different result views
public struct ResultView: View {
    
    @ObservedObject private var store: Store<SearchState, SearchAction>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
    }
    
    public var body: some View {
        if let model = store.value.model as? SongDisplayModel {
            ResultSongOverviewView(model: model, store: store)
        } else if let model = store.value.model as? AlbumDisplayModel {
//            ResultAlbumOverviewView()
        } else if let model = store.value.model as? PerformanceDisplayModel {
            ResultPerformanceOverviewView(model: model, store: store)
        }
    }
}