//
//  SearchViewModel.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 28/07/2022.
//

import Combine
import Foundation

protocol Model {
    var uuid: String { get }
}

class SearchViewModel: ObservableObject {
    
    private let detective = Detective()
    private let formatter = Formatter()
    private let cloudKitManager = CloudKitManager()
    private var cancellables: Set<AnyCancellable> = []
    
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
                delay(0.3) { [self] in
                    searchNextSearch(nextSearch.title)
                }
            }
        }
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
    
    func resetModels() {
        songModel = nil
        albumModel = nil
        performanceModel = nil
    }
    
    func handleModel(_ model: Model?) {
        guard let nextSearch = nextSearch else {
            return
        }
        self.nextSearch = nil
        if let model = model as? SongDisplayModel {
            songModel = model
        } else if let model = model as? AlbumDisplayModel {
            albumModel = model
        } else if let model = model as? PerformanceDisplayModel {
            performanceModel = model
        } else {
            switch nextSearch.type {
            case .album:
                search(.init(title: nextSearch.title, type: .song))
            case .song:
                search(.init(title: nextSearch.title, type: .performance))
            case .performance:
                shouldDisplayNoResultsFound = true
            }
        }
    }
    
    func searchNextSearch(_ text: String) {
        guard let nextSearch = nextSearch else {
            return
        }
        switch nextSearch.type {
        case .album:
            detective.search(song: text)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: handleModel(_:))
                .store(in: &cancellables)
        case .song:
            detective.search(song: text)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: handleModel(_:))
                .store(in: &cancellables)
        case .performance:
            if let toFetch = Double(text) ?? formatter.date(from: text) {
                detective.fetch(performance: toFetch)
                 .receive(on: DispatchQueue.main)
                 .sink(receiveValue: handleModel(_:))
                 .store(in: &cancellables)
            } else {
                shouldDisplayNoResultsFound = true
            }
        }
    }
}
