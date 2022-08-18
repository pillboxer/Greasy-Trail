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

// swiftlint: disable opening_brace

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
        return [{ callback in
            searcher.search(search) { model in
                DispatchQueue.main.async {
                    callback(.completeSearch(model, search))
                }
            }
        }]
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
    
    func search(_ search: Search, completion: @escaping (Model?) -> Void) {
        guard let type = search.type else {
            return self.search(Search(title: search.title, type: .album)) { model in
                if let model = model {
                    completion(model)
                } else {
                    self.search(Search(title: search.title, type: .song)) { model in
                        if let model = model {
                            completion(model)
                        } else {
                            self.search(Search(title: search.title, type: .performance), completion: completion)
                        }
                    }
                }
            }
        }
        switch type {
        case .album:
            detective.search(album: search.title, completion: completion)
        case .song:
            detective.search(song: search.title, completion: completion)
        case .performance:
            if let toFetch = Double(search.title) ?? formatter.date(from: search.title) {
                detective.fetch(performance: toFetch, completion: completion)
            } else {
                completion(nil)
            }
        }
    }

}
