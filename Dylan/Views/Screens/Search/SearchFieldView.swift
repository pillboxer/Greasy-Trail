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
        if let nextSearch = nextSearch {
            SearchingView()
                .onAppear {
                    searchNextSearch(nextSearch.title)
                }
        }
        else {
            HStack{
                NSTextFieldRepresentable(placeholder: "search_placeholder", text: $text) {
                    searchBlind()
                }
                .frame(maxWidth: 250)
                
                OnTapButton(systemImage: "magnifyingglass.circle") {
                    searchBlind()
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(4)
        }
    }
    
    private func searchBlind() {
        guard !text.isEmpty else {
            return
        }
        if let result = detective.search(album: text) {
            albumModel = result
        }
        else if let result = detective.search(song: text) {
            songModel = result
        }
        else if let formatted = formatter.date(from: text),
                let result = detective.fetch(performance: formatted) {
            performanceModel = result
        }
        else {
            searchDisplayType = .noResultsFound(title: text)
        }
    }
    
    private func searchNextSearch(_ text: String) {
        guard let nextSearch = nextSearch else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
                if let double = Double(text),
                   let result = detective.fetch(performance: double) {
                    performanceModel = result
                }
                else {
                    searchDisplayType = .noResultsFound(title: text)
                }
            }
            self.nextSearch = nil
        }
    }
    
}
