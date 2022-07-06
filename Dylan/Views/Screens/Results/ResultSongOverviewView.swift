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
            HStack {
                if let albums = model?.albums, albums.count > 1 {
                    OnTapButton(text: "Albums") {
                        currentViewType = .albums(albums)
                    }
                    Spacer()
                }
                if let performances = model?.performances, performances.count > 1  {
                    Spacer()
                        OnTapButton(text: "Performances") {
                            currentViewType = .performances(performances)
                    }
                }
            }
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
