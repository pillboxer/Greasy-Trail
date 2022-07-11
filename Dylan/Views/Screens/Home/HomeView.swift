//
//  HomeView.swift
//  Dylan
//
//  Created by Henry Cooper on 11/07/2022.
//

import SwiftUI

struct HomeView: View {
    
    enum RecentViewType: Int, CaseIterable {
        case albums
        case performances
        
        var pickerValue: String {
            "picker_value_\(String(rawValue))"
        }
    }
    @Binding var text: String
    @Binding var searchDisplayType: SearchView.SearchDisplayType
    @Binding var songModel: SongDisplayModel?
    @Binding var albumModel: AlbumDisplayModel?
    @Binding var performanceModel: PerformanceDisplayModel?
    @Binding var nextSearch: Search?
    
    var body: some View {
        VStack {
            if let _ = nextSearch {
                SearchFieldView(text: $text, nextSearch: $nextSearch, songModel: $songModel, albumModel: $albumModel, performanceModel: $performanceModel, searchDisplayType: $searchDisplayType)
            }
            else {
                RecentsView(nextSearch: $nextSearch)
                HStack {
                    Spacer()
                    SearchFieldView(text: $text, nextSearch: $nextSearch, songModel: $songModel, albumModel: $albumModel, performanceModel: $performanceModel, searchDisplayType: $searchDisplayType)
                }
            }
        }
        .padding()
    }
}
