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
    
    let store: Store<SearchState, SearchAction>
    private let formatter = GTFormatter.Formatter()
    private let model: SongDisplayModel
    
    public init(store: Store<SearchState, SearchAction>,
                model: SongDisplayModel) {
        self.model = model
        self.store = store
    }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(model.title)
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom)
            Spacer()
            HStack {
                if let performances = model.performances, !performances.isEmpty {
                    PerformancesListView(performances: performances, store: store.scope(state: {
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
