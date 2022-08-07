//
//  ResultOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI
import GTFormatter

struct ResultSongOverviewView: View {
    
    let formatter = GTFormatter.Formatter()
    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack {
            HStack {
                OnTapButton(systemImage: "house") {
                    searchViewModel.reset()
                }
                .buttonStyle(.plain)
                Spacer()
                Text(searchViewModel.songModel?.title ?? "")
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom)
            Spacer()
            HStack {
                if let albums = searchViewModel.songModel?.albums, !albums.isEmpty {
                    AlbumsListView(albums: albums) { title in
                        searchViewModel.search(.init(title: title, type: .album))
                    }
                }
                if let performances = searchViewModel.songModel?.performances, !performances.isEmpty {
                    PerformancesListView(performances: performances) { date in
                        searchViewModel.search(.init(title: date, type: .performance))
                    }
                }
            }
            Text("results_information_title_song_author")
                .font(.footnote)
                .bold()
            Text(searchViewModel.songModel?.author ?? "default_author")
                .font(.caption)
        }
        .padding()
    }

}
