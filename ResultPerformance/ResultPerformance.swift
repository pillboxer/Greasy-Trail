//
//  ResultPerformance.swift
//  ResultPerformance
//
//  Created by Henry Cooper on 08/08/2022.
//

import SwiftUI
import Model
import SongsList
import Search
import ComposableArchitecture
import UI

public struct ResultPerformanceOverviewView: View {
    
    let store: Store<SearchState, SearchAction>
    let model: PerformanceDisplayModel
    @State private var presentAlert = false
    
    public init(store: Store<SearchState, SearchAction>,
                model: PerformanceDisplayModel) {
        self.store = store
        self.model = model
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Text(model.venue)
                    .font(.headline)
                if let url = model.officialURL() {
                    OnTapButton(systemImage: "globe", plainButtonStyle: false) {
                        NSWorkspace.shared.open(url)
                    }
                    .buttonStyle(.link)
                }
                Spacer()
            }
            Text(model.date)
            Spacer()
            HStack {
                SongsListView(songs: model.songs) { title in
                    store.send(.makeSearch(.init(title: title, type: .song)))
                }
                Spacer()
            }
        }
        .padding()
    }
}
