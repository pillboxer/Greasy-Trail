//
//  ResultOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

struct ResultSongOvervewView: View {
    
    @Binding var model: SongDisplayModel?
    @Binding var currentViewType: ResultView.ResultViewType
    @EnvironmentObject var formatter: Formatter
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "house")
                    .onTapGesture {
                        model = nil
                    }
                Spacer()
                Text(model?.title ?? "")
                    .font(.headline)
                Spacer()
            }

            Spacer()
            ResultsInformationTitleAndDetailView(title: "results_information_title_song_author", detail: model?.author ?? "")
            albumInformationView
            Spacer()
            Spacer()
            if let albums = model?.albums, albums.count > 1 {
                HStack {
                    OnTapButton(text: "Albums") {
                        currentViewType = .albums(albums)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var albumInformationView: some View {
        if let first = model?.firstAlbumAppearance {
            ResultsInformationTitleAndDetailView(title: "results_information_title_first_appearance", detail: first.title)
        }
        else {
            Text("Never released on an album")
        }
    }
    
}
