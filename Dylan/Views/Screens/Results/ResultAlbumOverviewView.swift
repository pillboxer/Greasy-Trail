//
//  ResultAlbumOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import SwiftUI
import SongsList
import UI

struct ResultAlbumOverviewView: View {

    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                OnTapButton(systemImage: "house") {
                    searchViewModel.reset()
                }
                Spacer()
                Text(searchViewModel.albumModel?.title ?? "")
                    .font(.headline)
                Spacer()
            }
            Spacer()
            HStack {
                SongsListView(songs: searchViewModel.albumModel?.songs ?? []) { title in
                    searchViewModel.search(.init(title: title, type: .song))
                }
            }
        }
        .padding()
    }
}
