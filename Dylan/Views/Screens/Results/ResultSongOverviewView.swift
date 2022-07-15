//
//  ResultOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

struct ResultSongOverviewView: View {
    
    @Binding var model: SongDisplayModel?
    @Binding var currentViewType: ResultView.ResultViewType
    @Binding var nextSearch: Search?

    @EnvironmentObject var formatter: Formatter
    
    var body: some View {
        VStack {
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
            .padding(.bottom)
            Spacer()
            HStack {
                if let albums = model?.albums, !albums.isEmpty {
                    AlbumsListView(albums: albums) { title in
                        nextSearch = Search(title: title, type: .album)
                        model = nil
                    }
                }
                if let performances = model?.performances, !performances.isEmpty {
                    PerformancesListView(performances: performances) { date in
                        nextSearch = Search(title: date, type: .performance)
                        model = nil
                    }
                }
            }
            Text("results_information_title_song_author")
                .font(.footnote)
                .bold()
            Text(model?.author ?? "default_author")
                .font(.caption)
        }
        .padding()
    }
    
    @ViewBuilder
    private var albumInformationView: some View {
        if let firstAlbum = model?.firstAlbumAppearance {
            ResultsInformationTitleAndDetailView(title: "results_information_title_first_appearance", detail: firstAlbum.title)
        }
        else {
            ResultsInformationTitleAndDetailView(title: "results_information_title_first_appearance", detail: "Never")
        }
        if let firstPerformance = model?.firstPerformance {
            ResultsInformationTitleAndDetailView(title: "results_information_title_first_live_performance", detail: formatter.formatted(performance: firstPerformance))
        }
        else {
            ResultsInformationTitleAndDetailView(title: "results_information_title_first_live_performance", detail: "Never")
        }
    }
    
}
