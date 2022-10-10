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
    @ObservedObject private var viewStore: ViewStore<ResultViewState, Never>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = ViewStore(store.actionless.scope(state: { ResultViewState(
            failedSearch: $0.failedSearch,
            model: $0.model,
            currentSearchTitle: $0.currentSearch?.title)
        }))
    }
    
    struct ResultViewState: Equatable {
        let failedSearch: Search?
        let model: AnyModel?
        let currentSearchTitle: String?
    }
    
    private var model: AnyModel? {
        viewStore.model
    }
    
    public var body: some View {
        VStack {
            if let model = model?.value as? SongDisplayModel {
                ResultSongOverviewView(store: store, model: model)
            } else if let model = model?.value as? AlbumDisplayModel {
                ResultAlbumOverviewView(store: store, model: model)
            } else if let model = model?.value as? PerformanceDisplayModel {
                ResultPerformanceOverviewView(store: store, model: model)
            } else if viewStore.failedSearch != nil {
                VStack {
                    HStack {
                        Spacer()
                        Text("No results found for \(viewStore.currentSearchTitle ?? "search")")
                        Spacer()
                    }
                }
                .font(.caption)
                .frame(maxHeight: .infinity)
            }
        }
        .frame(maxHeight: .infinity)
    }
}
