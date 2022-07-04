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
        case albums([Album])
    }
    
    @Binding var songModel: SongDisplayModel?
    @Binding var albumModel: AlbumDisplayModel?
    @State private var currentViewType: ResultViewType
    @Binding var nextSearch: Search?
    
    init(songModel: Binding<SongDisplayModel?> = .constant(nil), albumModel: Binding<AlbumDisplayModel?> = .constant(nil), nextSearch: Binding<Search?>) {
        _songModel = songModel
        _albumModel = albumModel
        self.currentViewType = songModel.wrappedValue != nil ? .songOverview : .albumOverview
        self._nextSearch = nextSearch
    }
    
    var body: some View {
        switch currentViewType {
        case .songOverview:
            ResultSongOvervewView(model: $songModel, currentViewType: $currentViewType)
        case .albums(let albums):
            ResultAlbumsTableView(albums: albums, model: $songModel, nextSearch: $nextSearch, currentViewType: $currentViewType)
        case .albumOverview:
            ResultAlbumOverviewView(model: $albumModel, nextSearch: $nextSearch)
        }
    }
    
}
