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
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<AnyModel?>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = store.scope(value: { $0.model}, action: {$0 }).view(id: "RESULTS")
    }
    
    private var model: AnyModel? {
        viewStore.value
    }
    
    public var body: some View {
        if let model = model?.value as? SongDisplayModel {
            ResultSongOverviewView(model: model, store: store)
        } else if let model = model?.value as? AlbumDisplayModel {
//            ResultAlbumOverviewView()
        } else if let model = model?.value as? PerformanceDisplayModel {
            ResultPerformanceOverviewView(model: model, store: store)
        }
    }
}
