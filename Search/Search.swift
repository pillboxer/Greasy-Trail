//
//  Search.swift
//  Search
//
//  Created by Henry Cooper on 07/08/2022.
//

import Model
import Combine
import Core
import GTFormatter
// Rename
public enum DylanSearchType {
    case song
    case album
    case performance
}

public class SearchState: ObservableObject {
    public var model: Model?
    public var failedSearch: Search?
    @Published public var currentSearch: Search?
    
    public init(model: Model?, failedSearch: Search?, currentSearch: Search?) {
        self.model = model
        self.failedSearch = failedSearch
        self.currentSearch = currentSearch
    }
}

public struct Search: Equatable {
    public let title: String
    public let type: DylanSearchType?
    
    public init(title: String, type: DylanSearchType?) {
        self.title = title
        self.type = type
    }
}

public enum SearchAction {
    case makeSearch(Search)
    case reset
}

public func searchReducer(state: inout SearchState, action: SearchAction) {
    switch action {
    case .makeSearch(let search):
        // FIXME: Not updating UI
        state.currentSearch = search
        let searcher = Searcher()
        state.model = searcher.search(search)
        let didFail = state.model == nil
        state.failedSearch = didFail ? search : nil
        state.currentSearch = nil
    case .reset:
        state.failedSearch = nil
        state.model = nil
    }
}

private class Searcher {
    
    private let formatter = GTFormatter.Formatter()
    var cancellables: Set<AnyCancellable> = []
    
    func search(_ search: Search) -> Model? {
        let detective = Detective()
        
        guard let type = search.type else {
            return self.search(Search(title: search.title, type: .album)) ??
            self.search(Search(title: search.title, type: .song)) ??
            self.search(Search(title: search.title, type: .performance))
        }
        
        switch type {
        case .album:
            return detective.search(album: search.title)
        case .song:
            return detective.search(song: search.title)
        case .performance:
            if let toFetch = Double(search.title) ?? formatter.date(from: search.title) {
                return detective.fetch(performance: toFetch)
            } else {
                return nil
            }
        }
    }
}
