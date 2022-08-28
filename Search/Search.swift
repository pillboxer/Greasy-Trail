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

public struct SearchEnvironment {
    public let search: (Search) -> Effect<AnyModel?>
    public let randomSong: () -> Effect<SongDisplayModel?>
    public let randomAlbum: () -> Effect<AlbumDisplayModel?>
    public let randomPerformance: () -> Effect<PerformanceDisplayModel?>
    
    public init(search: @escaping (Search) -> Effect<AnyModel?>,
                randomSong: @escaping () -> Effect<SongDisplayModel?>,
                randomAlbum: @escaping () -> Effect<AlbumDisplayModel?>,
                randomPerformance: @escaping () -> Effect<PerformanceDisplayModel?>) {
        self.search = search
        self.randomSong = randomSong
        self.randomAlbum = randomAlbum
        self.randomPerformance = randomPerformance
    }
}

public enum DylanSearchType: CaseIterable {
    case song
    case album
    case performance
}

public class SearchState: ObservableObject, Equatable {
    public static func == (lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.model == rhs.model
        && lhs.failedSearch == rhs.failedSearch
        && lhs.currentSearch == rhs.currentSearch
    }
    
    public var model: AnyModel?
    public var failedSearch: Search?
    public var currentSearch: Search?
    public var ids: Set<ObjectIdentifier>
    public var isSearching = false
    
    public init(model: AnyModel?,
                failedSearch: Search?,
                currentSearch: Search?,
                ids: Set<ObjectIdentifier>,
                isSearching: Bool) {
        self.model = model
        self.failedSearch = failedSearch
        self.currentSearch = currentSearch
        self.ids = ids
        self.isSearching = isSearching
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

public enum SearchAction: Equatable {
    case select(identifier: ObjectIdentifier)
    case makeSearch(Search)
    case completeSearch(AnyModel?, Search)
    case makeRandomSearch
    case todayInHistory
    case reset
}

public func searchReducer(state: inout SearchState,
                          action: SearchAction,
                          environment: SearchEnvironment) -> [Effect<SearchAction>] {
    
    switch action {
    case .makeSearch(let search):
        state.isSearching = true
        state.currentSearch = search
        return [searchEffect(search: search, environment: environment)]
    case .completeSearch(let model, let search):
        state.isSearching = false
        state.model = model ?? state.model
        state.failedSearch = model == nil ? search : nil
        return []
    case .reset:
        state.currentSearch = nil
        state.failedSearch = nil
        state.model = nil
        return []
    case .select(let identifier):
        state.ids.removeAll()
        state.ids.insert(identifier)
        return []
    case .todayInHistory:
        print("Today in history")
        return []
    case .makeRandomSearch:
        state.isSearching = true
        let random = DylanSearchType.allCases.randomElement()!
        return [randomSearchEffect(environment: environment, type: random)]
    }
}

private func searchEffect(search: Search,
                          environment: SearchEnvironment) -> Effect<SearchAction> {
    environment.search(search)
        .map {
            return .completeSearch($0, search)
        }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
}

private func randomSearchEffect(environment: SearchEnvironment,
                                type: DylanSearchType) -> Effect<SearchAction> {
    switch type {
    case .song:
        return environment.randomSong()
            .map { model in
                guard let model = model else { return .reset }
                return .completeSearch(AnyModel(model), Search(title: model.title, type: .song))
            }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    case .album:
        return environment.randomAlbum()
            .map { model in
                guard let model = model else { return .reset }
                return .completeSearch(AnyModel(model), Search(title: model.title, type: .album))
            }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    case .performance:
        return environment.randomPerformance()
            .map { model in
                guard let model = model else { return .reset }
                return .completeSearch(AnyModel(model), Search(title: model.venue, type: .performance))
            }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    }
    
}

public class Searcher {
    
    private let formatter = GTFormatter.Formatter()
    private var cancellables: Set<AnyCancellable> = []
    private let detective = Detective()
    
    public init() {}
    
    public func randomSong() -> Effect<SongDisplayModel?> {
        detective.randomSong()
    }
    
    public func randomAlbum() -> Effect<AlbumDisplayModel?> {
        detective.randomAlbum()
    }
    
    public func randomPerformance() -> Effect<PerformanceDisplayModel?> {
        detective.randomPerformance()
    }
    
    public func search(_ search: Search) -> Effect<AnyModel?> {
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
