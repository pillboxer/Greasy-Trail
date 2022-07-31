//
//  ResultView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

/// Coordinates between different result views
struct ResultView: View {
    
    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    var body: some View {
        if searchViewModel.songModel != nil {
            ResultSongOverviewView()
        } else if searchViewModel.albumModel != nil {
            ResultAlbumOverviewView()
        } else if let model = searchViewModel.performanceModel {
            ResultPerformanceOverviewView(editorViewModel: EditorViewModel(editable: model.sPerformance))
        }
    }
}
