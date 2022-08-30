//
//  ResultAlbumOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import SwiftUI
import SongsList
import UI
import Model
import ComposableArchitecture
import Search

public struct ResultAlbumOverviewView: View {
    
    enum ResultAlbumOverviewAction {
        case search(Search)
    }
    
    private struct ResultAlbumOverviewState: Equatable {}
    
    let store: Store<SearchState, SearchAction>
    
    @ObservedObject private var viewStore: ViewStore<ResultAlbumOverviewState, ResultAlbumOverviewAction>
    private let model: AlbumDisplayModel
    
    public init(store: Store<SearchState, SearchAction>,
                model: AlbumDisplayModel) {
        self.store = store
        self.viewStore = store.scope(value: { _ in return ResultAlbumOverviewState() },
                                     action: SearchAction.init).view
        self.model = model
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Text(model.title)
                    .font(.headline)
                Spacer()
            }
            Spacer()
            HStack {
                SongsListView(songs: model.songs) { title in
                    viewStore.send(.search(.init(title: title, type: .song)))
                }
            }
        }
        .padding()
    }
}

fileprivate extension SearchAction {
    
    init(action: ResultAlbumOverviewView.ResultAlbumOverviewAction) {
        switch action {
        case .search(let search):
            self = .makeSearch(search)
        }
    }
}
