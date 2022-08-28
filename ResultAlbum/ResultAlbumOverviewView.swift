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
    
    let store: Store<SearchState, SearchAction>
    private let model: AlbumDisplayModel
    
    public init(store: Store<SearchState, SearchAction>,
                model: AlbumDisplayModel) {
        self.store = store
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
                    store.send(.makeSearch(Search(title: title, type: .song)))
                }
            }
        }
        .padding()
    }
}
