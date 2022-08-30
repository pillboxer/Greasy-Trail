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
import GTFormatter
import ComposableArchitecture
import UI

public struct ResultPerformanceOverviewView: View {
    
    fileprivate enum ResultPerformanceAction {
        case search(Search)
    }
    
    private struct ResultPerformanceState: Equatable {}
    
    private let formatter = GTFormatter.Formatter()
    let store: Store<SearchState, SearchAction>
    let model: PerformanceDisplayModel
    @ObservedObject private var viewStore: ViewStore<ResultPerformanceState, ResultPerformanceAction>

    public init(store: Store<SearchState, SearchAction>,
                model: PerformanceDisplayModel) {
        self.store = store
        self.viewStore = store.scope(value: { _ in ResultPerformanceState() },
                                     action: SearchAction.init).view
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
            Text(formatter.dateString(of: model.date))
            Spacer()
            HStack {
                SongsListView(songs: model.songs) { title in
                    viewStore.send(.search(.init(title: title, type: .song)))
                }
                Spacer()
            }
        }
        .padding()
    }
}

fileprivate extension SearchAction {
    
    init(action: ResultPerformanceOverviewView.ResultPerformanceAction) {
        switch action {
        case .search(let search):
            self = .makeSearch(search)
        }
    }
}
