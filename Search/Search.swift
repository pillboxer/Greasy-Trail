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
import ComposableArchitecture

public enum DylanSearchType {
    case song
    case album
    case performance
    
    var nextType: DylanSearchType? {
        switch self {
        case .song:
            return .performance
        case .album:
            return .song
        case .performance:
            return nil
        }
    }
}

private let searcher = Searcher()

public class SearchState: ObservableObject {
    public var model: Model?
    public var failedSearch: Search?
    public var currentSearch: Search?
    
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
    case completeSearch(Model?, Search)
    case reset
}

public func searchReducer(state: inout SearchState, action: SearchAction) -> [Effect<SearchAction>] {
    
    switch action {
    case .makeSearch(let search):
        state.currentSearch = search
        return [ searcher.search(search)
            .map {
                return .completeSearch($0, search)
            }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()]
    case .completeSearch(let model, let search):
        state.model = model
        state.failedSearch = model == nil ? search : nil
        return []
    case .reset:
        state.currentSearch = nil
        state.failedSearch = nil
        state.model = nil
        return []
    }
}

private class Searcher {
    
    private let formatter = GTFormatter.Formatter()
    private var cancellables: Set<AnyCancellable> = []
    private let detective = Detective()
    
    func search(_ search: Search) -> Effect<Model?> {
        guard let type = search.type else {
            return [self.search(Search(title: search.title, type: .album)),
                    self.search(Search(title: search.title, type: .song)),
                    self.search(Search(title: search.title, type: .performance))]
                .publisher
                .flatMap(maxPublishers: .max(1)) { $0 }
                .compactMap { $0 }
                .replaceEmpty(with: nil)
                .eraseToEffect()
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
                return Just(nil)
                    .eraseToEffect()
            }
        }
    }
    
}
