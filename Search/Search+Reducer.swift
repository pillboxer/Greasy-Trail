import ComposableArchitecture
import Model

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
    case .reset(let displayedView):
        state.currentSearch = nil
        state.failedSearch = nil
        state.model = nil
        state.selectedObjectID = nil
        state.selectedID = nil
        state.searchFieldText = ""
        return Effect(value: .selectDisplayedView(displayedView, nil))
    case .select(let objectIdentifier, let objectID):
        state.selectedObjectID = objectID
        return Effect(value: .selectID(objectIdentifier: objectIdentifier))
    case .selectID(let objectIdentifier):
        state.selectedID = objectIdentifier
    case .makeRandomSearch:
        state.isSearching = true
        let random = DylanSearchType.allCases.randomElement()!
        return randomSearchEffect(environment: environment, type: random)
    case .setSearchFieldText(let string):
        state.searchFieldText = string
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
                guard let model = model else { return .reset(.home) }
                return .completeSearch(AnyModel(model), Search(title: model.title, type: .song))
            }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    case .album:
        return environment.randomAlbum()
            .map { model in
                guard let model = model else { return .reset(.home) }
                return .completeSearch(AnyModel(model), Search(title: model.title, type: .album))
            }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    case .performance:
        return environment.randomPerformance()
            .map { model in
                guard let model = model else { return .reset(.home) }
                return .completeSearch(AnyModel(model), Search(title: model.venue, type: .performance))
            }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    }
    
}
