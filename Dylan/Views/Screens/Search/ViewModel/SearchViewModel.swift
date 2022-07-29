//
//  SearchViewModel.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 28/07/2022.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
    
    private let detective = Detective()
    private let formatter = Formatter()
    private let cloudKitManager: CloudKitManager
    
    @Published var text: String = ""
    
    @Published var songModel: SongDisplayModel?
    @Published var albumModel: AlbumDisplayModel?
    @Published var performanceModel: PerformanceDisplayModel?
    
    @Published var shouldDisplaySearch = false
    @Published private(set) var shouldDisplayNoResultsFound = false
    
    var hasResult: Bool {
        (songModel != nil || albumModel != nil || performanceModel != nil)
    }
    
    private var nextSearch: Search? {
        didSet {
            shouldDisplaySearch = nextSearch != nil
            if let nextSearch = nextSearch {
                searchNextSearch(nextSearch.title)
            }
        }
    }
    
    init(cloudKitManager: CloudKitManager) {
        self.cloudKitManager = cloudKitManager
    }
}

extension SearchViewModel {
    
    func searchBlind() {
        guard !text.isEmpty else {
            return
        }
        nextSearch = Search(title: text, type: .album)
    }
    
    func search(_ search: Search) {
        resetModels()
        self.nextSearch = search
    }
    
    func refresh() {
        Task {
            await cloudKitManager.start()
        }
    }
    
    func reset() {
        text = ""
        nextSearch = nil
        shouldDisplayNoResultsFound = false
        resetModels()
    }
    
}

private extension SearchViewModel {
    
    private func resetModels() {
        songModel = nil
        albumModel = nil
        performanceModel = nil
    }
    
    func searchNextSearch(_ text: String) {
        guard let nextSearch = nextSearch else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            switch nextSearch.type {
            case .album:
                if let result = detective.search(album: text) {
                    albumModel = result
                    self.nextSearch = nil
                } else {
                    self.nextSearch = Search(title: text, type: .song)
                }
            case .song:
                if let result = detective.search(song: text) {
                    songModel = result
                    self.nextSearch = nil
                } else {
                    self.nextSearch = Search(title: text, type: .performance)
                }
            case .performance:
                if let toFetch = Double(text) ?? formatter.date(from: text),
                   let result = detective.fetch(performance: toFetch) {
                    performanceModel = result
                    self.nextSearch = nil
                } else {
                    shouldDisplayNoResultsFound = true
                }
            }
        }
    }
}
