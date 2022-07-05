//
//  SearchView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

// Rename
enum DylanSearchType {
    case song
    case album
}

struct SearchView: View {
    
    @State private var text: String = ""
    @Binding var songModel: SongDisplayModel?
    @Binding var albumModel: AlbumDisplayModel?
    @Binding var nextSearch: Search?
    
    @State private var searchDisplayType: SearchDisplayType = .search
    
    enum SearchDisplayType {
        case search
        case searching
        case noResultsFound(title: String)
    }
    
    var body: some View {
        switch searchDisplayType {
        case .search:
            SearchFieldView(text: $text, nextSearch: $nextSearch, songModel: $songModel, albumModel: $albumModel, searchDisplayType: $searchDisplayType)
        case .searching:
            SearchingView()
        case .noResultsFound(let title):
            Text("No results found for \(title)")
            Button("OK") {
                searchDisplayType = .search
            }
        
        }
    }
    
}