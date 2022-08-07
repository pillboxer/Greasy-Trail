//
//  Search.swift
//  Search
//
//  Created by Henry Cooper on 07/08/2022.
//

import Model
import Combine
import GTFormatter
// Rename
public enum DylanSearchType {
    case song
    case album
    case performance
}

public struct Search: Equatable {
    public let title: String
    public let type: DylanSearchType
    
    public init(title: String, type: DylanSearchType) {
        self.title = title
        self.type = type
    }
}

public enum SearchAction {
    case makeSearch(Search)
}

public func searchReducer(state: inout  Model?, action: SearchAction) {
    print("*** In search reducer ***")
    switch action {
    case .makeSearch(let search):
        let searcher = Searcher()
        state = searcher.search(search)
    }
}

private class Searcher {
    
    private let formatter = GTFormatter.Formatter()
    var cancellables: Set<AnyCancellable> = []
    
    func search(_ search: Search) -> Model? {
        let detective = Detective()
        switch search.type {
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
