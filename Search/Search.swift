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
import CoreData
import GTCloudKit
import Detective
import ComposableArchitecture

public struct SearchEnvironment {
    public let search: (Search) -> Effect<AnyModel?, Never>
    public let randomSong: () -> Effect<SongDisplayModel?, Never>
    public let randomAlbum: () -> Effect<AlbumDisplayModel?, Never>
    public let randomPerformance: () -> Effect<PerformanceDisplayModel?, Never>
    
    public init(search: @escaping (Search) -> Effect<AnyModel?, Never>,
                randomSong: @escaping () -> Effect<SongDisplayModel?, Never>,
                randomAlbum: @escaping () -> Effect<AlbumDisplayModel?, Never>,
                randomPerformance: @escaping () -> Effect<PerformanceDisplayModel?, Never>) {
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

public struct SearchState: Equatable {
    public static func == (lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.model == rhs.model
        && lhs.failedSearch == rhs.failedSearch
        && lhs.currentSearch == rhs.currentSearch
    }
    
    public var model: AnyModel?
    public var displayedView: DisplayedView
    public var failedSearch: Search?
    public var currentSearch: Search?
    public var selectedID: ObjectIdentifier?
    public var selectedObjectID: NSManagedObjectID?
    public var isSearching = false
    
    public init(model: AnyModel?,
                displayedView: DisplayedView,
                failedSearch: Search?,
                currentSearch: Search?,
                selectedID: ObjectIdentifier?,
                selectedObjectID: NSManagedObjectID?,
                isSearching: Bool) {
        self.model = model
        self.failedSearch = failedSearch
        self.currentSearch = currentSearch
        self.selectedID = selectedID
        self.selectedObjectID = selectedObjectID
        self.isSearching = isSearching
        self.displayedView = displayedView
    }
}

public struct Search: Equatable {
    public var title: String?
    public var type: DylanSearchType?
    public var id: NSManagedObjectID?
    
    public init(title: String, type: DylanSearchType?) {
        self.title = title
        self.type = type
    }
    
    public init(id: NSManagedObjectID) {
        self.id = id
    }
}

public enum SearchAction: Equatable {
    case selectID(objectIdentifier: ObjectIdentifier?)
    case select(objectIdentifier: ObjectIdentifier?, objectID: NSManagedObjectID?)
    case makeSearch(Search)
    case completeSearch(AnyModel?, Search)
    case makeRandomSearch
    case selectDisplayedView(DisplayedView, AnyModel?)
    case todayInHistory
    case reset
}

public let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> { state, action, environment in
    switch action {
    case .makeSearch(let search):
        state.isSearching = true
        state.currentSearch = search
        return searchEffect(search: search, environment: environment)
    case .completeSearch(let model, let search):
        state.isSearching = false
        state.model = model ?? state.model
        state.failedSearch = model == nil ? search : nil
        return Effect(value: .selectDisplayedView(.result, model))
    case .reset:
        state.currentSearch = nil
        state.failedSearch = nil
        state.model = nil
        state.selectedObjectID = nil
        state.selectedID = nil
        return Effect(value: .selectDisplayedView(.home, nil))
    case .select(let objectIdentifier, let objectID):
        state.selectedObjectID = objectID
        return Effect(value: .selectID(objectIdentifier: objectIdentifier))
    case .selectID(let objectIdentifier):
        state.selectedID = objectIdentifier
    case .todayInHistory:
        print("Today in history")
    case .makeRandomSearch:
        state.isSearching = true
        let random = DylanSearchType.allCases.randomElement()!
        return randomSearchEffect(environment: environment, type: random)
    case .selectDisplayedView(let displayedView, let model):
        if state.displayedView.isAdding && displayedView == .result {
            if (model?.value as? PerformanceDisplayModel) != nil {
                state.displayedView = .add(.performances)
            } else if (model?.value as? AlbumDisplayModel) != nil {
                state.displayedView = .add(.albums)
            } else if (model?.value as? SongDisplayModel) != nil {
                state.displayedView = .add(.songs)
            }
        } else {
            state.displayedView = displayedView 
        }
    }
    return .none
}

private func searchEffect(search: Search,
                          environment: SearchEnvironment) -> Effect<SearchAction, Never> {
    environment.search(search)
        .map {
            return .completeSearch($0, search)
        }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
}

private func randomSearchEffect(environment: SearchEnvironment,
                                type: DylanSearchType) -> Effect<SearchAction, Never> {
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
