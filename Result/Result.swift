//
//  ResultView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI
import ComposableArchitecture
import ResultPerformance
import ResultAlbum
import ResultSongOverview
import Model
import Search

/// Coordinates between different result views
public struct ResultView: View {
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<AnyModel?, Never>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = store.scope(value: { $0.model}, action: nil).view
    }
    
    private var model: AnyModel? {
        viewStore.value
    }
    
    public var body: some View {
        if let model = model?.value as? SongDisplayModel {
            ResultSongOverviewView(store: store, model: model)
        } else if let model = model?.value as? AlbumDisplayModel {
            ResultAlbumOverviewView(store: store, model: model)
        } else if let model = model?.value as? PerformanceDisplayModel {
            ResultPerformanceOverviewView(store: store, model: model)
        }
    }
}
