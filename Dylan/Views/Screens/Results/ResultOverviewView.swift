//
//  ResultOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

struct ResultOverviewView: View {
    
    let model: SongDisplayModel
    @Binding var currentViewType: ResultView.ResultViewType
    @EnvironmentObject var formatter: Formatter
    
    var body: some View {
        VStack(spacing: 16) {
            Text(model.song.title)
                .font(.headline)
            Spacer()
            ResultsInformationTitleAndDetailView(title: "results_information_title_song_author", detail: model.author)
            albumInformationView
            Spacer()
            Spacer()
            if let albums = model.albums, albums.count > 1 {
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
        if let first = model.firstAlbumAppearance {
            ResultsInformationTitleAndDetailView(title: "results_information_title_first_appearance", detail: first.title)
            if let performance = model.firstLivePerformance {
                ResultsInformationTitleAndDetailView(title: "results_information_title_first_live_performance", detail: formatter.formatted(performance: performance))
            }
        }
        else {
            Text("Never released on an album")
        }
    }
    
}
