//
//  SearchFieldView.swift
//  Dylan
//
//  Created by Henry Cooper on 04/07/2022.
//

import SwiftUI

struct SearchFieldView: View {
    
    @Binding var text: String
    @Binding var nextSearch: Search?
    @Binding var songModel: SongDisplayModel?
    @Binding var albumModel: AlbumDisplayModel?
    @Binding var performanceModel: PerformanceDisplayModel?
    @Binding var searchDisplayType: SearchView.SearchDisplayType

    @EnvironmentObject private var formatter: Formatter
    
    @StateObject private var detective = Detective()

    var body: some View {
        VStack {
            HStack{
                Spacer()
                NSTextFieldRepresentable(placeholder: "search_placeholder", text: $text)
                    .frame(maxWidth: 250)
                Spacer()
            }
            HStack(spacing: 16) {
                OnTapButton(text: "Search") {
                    Task { await searchBlind() }
                }
            }
        }
        .padding(.bottom, 16)
        .onAppear {
            if let nextSearch = nextSearch {
                text = nextSearch.title
                Task { await searchNextSearch() }
            }
        }
    }
    
    private func prepareToSearch() {
    }
    
    private func searchBlind() async {
        searchDisplayType = .searching
        if let result = detective.search(album: text) {
            albumModel = result
        }
        else if let result = detective.search(song: text) {
            songModel = result
        }
        else if let formatted = formatter.date(from: text){} // FIXME:
        else {
            searchDisplayType = .noResultsFound(title: text)
        }
    }
    
    private func searchNextSearch() async {
        searchDisplayType = .searching
        guard let nextSearch = nextSearch else {
            return
        }
        switch nextSearch.type {
        case .album:
            if let result = detective.search(album: text) {
                albumModel = result
            }
            else {
                searchDisplayType = .noResultsFound(title: text)
            }
        case .song:
            if let result = detective.search(song: text) {
                songModel = result
            }
            else {
                searchDisplayType = .noResultsFound(title: text)
            }
        case .performance:
            if let formatted = formatter.date(from: text) {}
            // FIXME
            else {
                searchDisplayType = .noResultsFound(title: text)
            }
        }
        self.nextSearch = nil
    }
    
}
