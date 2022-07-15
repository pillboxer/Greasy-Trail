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
    
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @EnvironmentObject private var formatter: Formatter
    
    @StateObject private var detective = Detective()
    
    var body: some View {
        if let nextSearch = nextSearch {
            SearchingView()
                .onAppear {
                    searchNextSearch(nextSearch.title)
                }
                .onChange(of: nextSearch) { newValue in
                    searchNextSearch(newValue.title)
                }
        }
        else {
            HStack {
                OnTapButton(systemImage: "arrow.clockwise") {
                    self.refresh()
                }
                .buttonStyle(.plain)
                NSTextFieldRepresentable(placeholder: "search_placeholder", text: $text) {
                    searchBlind()
                }
                .frame(maxWidth: 250)
                OnTapButton(systemImage: "magnifyingglass.circle") {
                    searchBlind()
                }
                .buttonStyle(.plain)
            }
            .padding(4)
        }
    }
    
    private func refresh() {
        Task {
            try? await cloudKitManager.start()
        }
    }
    
    private func searchBlind() {
        guard !text.isEmpty else {
            return
        }
        nextSearch = Search(title: text, type: .album)
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
                    self.nextSearch = nil
                }
                else {
                    self.nextSearch = Search(title: text, type: .song)
                }
            case .song:
                if let result = detective.search(song: text) {
                    songModel = result
                    self.nextSearch = nil
                }
                else {
                    self.nextSearch = Search(title: text, type: .performance)
                }
            case .performance:
                if let toFetch = Double(text) ?? formatter.date(from: text),
                   let result = detective.fetch(performance: toFetch) {
                    performanceModel = result
                    self.nextSearch = nil
                }
                else {
                    searchDisplayType = .noResultsFound(title: text)
                }
            }
            
        }
    }

}
