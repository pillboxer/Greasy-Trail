//
//  ResultView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

/// Coordinates between different result views
struct ResultView: View {

    enum ResultViewType {
        case songOverview
        case albumOverview
        case albums([sAlbum])
        case performances([sPerformance])
        case performanceOverview
    }

    @Binding var songModel: SongDisplayModel?
    @Binding var albumModel: AlbumDisplayModel?
    @Binding var performanceModel: PerformanceDisplayModel?

    @State private var currentViewType: ResultViewType
    @Binding var nextSearch: Search?

    init(songModel: Binding<SongDisplayModel?> = .constant(nil),
         albumModel: Binding<AlbumDisplayModel?> = .constant(nil),
         performanceModel: Binding<PerformanceDisplayModel?> = .constant(nil),
         nextSearch: Binding<Search?>,
         currentViewType: ResultViewType) {
        _songModel = songModel
        _albumModel = albumModel
        _performanceModel = performanceModel
        self.currentViewType = currentViewType
        self._nextSearch = nextSearch
    }

    var body: some View {
        switch currentViewType {
        case .songOverview:
            ResultSongOverviewView(model: $songModel,
                                   currentViewType: $currentViewType,
                                   nextSearch: $nextSearch)
        case .albums(let albums):
            let models = albums.compactMap { TableDisplayModel(column1Value: $0.title,
                                                               column2Value: $0.releaseDate) }
            TwoColumnTableView(models: models,
                               songDisplayModel: $songModel,
                               nextSearch: $nextSearch,
                               currentViewType: $currentViewType)
        case .albumOverview:
            ResultAlbumOverviewView(model: $albumModel,
                                    nextSearch: $nextSearch)
        case .performances(let performances):
            let models = performances.compactMap { TableDisplayModel(column1Value: $0.venue,
                                                                     column2Value: $0.date ?? -1)  }
            TwoColumnTableView(models: models,
                               songDisplayModel: $songModel,
                               nextSearch: $nextSearch,
                               currentViewType: $currentViewType)
        case .performanceOverview:
            ResultPerformanceOverviewView(model: $performanceModel,
                                          nextSearch: $nextSearch,
                                          currentViewType: $currentViewType)
        }
    }

}
