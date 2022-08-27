//
//  ResultOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI
import GTFormatter
import UI
import Model
import ComposableArchitecture
import PerformancesList
import Search
public struct ResultSongOverviewView: View {
    
    @ObservedObject private var store: Store<SearchState, SearchAction>
    private let formatter = GTFormatter.Formatter()
    private let model: SongDisplayModel
    
    public init(model: SongDisplayModel, store: Store<SearchState, SearchAction>) {
        self.model = model
        self.store = store
    }
    
    public var body: some View {
        VStack {
            HStack {
                OnTapButton(systemImage: "house") {
                    store.send(.reset)
                }
                .buttonStyle(.plain)
                Spacer()
                Text(model.title)
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom)
            Spacer()
            HStack {
                if let performances = model.performances, !performances.isEmpty {
                    PerformancesListView(performances: performances, store: store.scope(value: {
                        $0.model
                    }, action: {
                        $0
                    }))
                }
            }
            Text("results_information_title_song_author")
                .font(.footnote)
                .bold()
            Text(model.author)
                .font(.caption)
        }
        .padding()
    }

}
