import SwiftUI
import ComposableArchitecture
import UI
import SearchField
import GTCloudKit
import Core
import os
import Search
import Model

// swiftlint: disable cyclomatic_complexity

let logger = Logger(subsystem: .subsystem, category: "Bottom Bar")

public struct BottomBarView: View {
    
    let store: Store<BottomBarState, BottomBarFeatureAction>
    @ObservedObject var viewStore: ViewStore<BottomBarViewState, BottomViewAction>
    
    public init(store: Store<BottomBarState, BottomBarFeatureAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: BottomBarViewState.init, action: BottomBarFeatureAction.init))
    }
    
    public var body: some View {
        HStack {
            switch viewStore.displayedView {
            case .donate:
                homeButton
            case .add:
                addButtons
            case .result:
                resultButtons
            case .songs, .albums, .performances:
                selectedWorkButtons
            case .home:
                refreshButton
                Spacer()
                recordButtons
            case .missingLBs:
                homeButton
                Spacer()
            }
            if viewStore.hasLoadedInAppPurchases, viewStore.displayedView != .donate {
                donateButton
            }
            if viewStore.isSearching {
                ProgressView()
                    .scaleEffect(0.4)
                    .help("bottom_bar_tooltip_progress")
            }
        }
        .padding()
        .frame(maxHeight: 36)
    }
}

private extension BottomBarView {
    
    @ViewBuilder
    var recordButtons: some View {
        songButton
        albumButton
        performanceButton
    }
    
    @ViewBuilder
    var addButtons: some View {
        closeAddButton
        Spacer()
        songButton
        albumButton
        performanceButton
        Spacer()
        uploadButton
    }
    
    @ViewBuilder
    var resultButtons: some View {
        homeButton
        searchButtonView
        randomButton
        favoriteButton
        Spacer()
        recordButtons
    }
    
    @ViewBuilder
    var selectedWorkButtons: some View {
        homeButton
        if viewStore.selectedObjectID != nil {
            editButton
        }
        searchButtonView
        randomButton
        if viewStore.displaysAdminFunctionality {
            openAddButton
        }
        Spacer()
        recordButtons
    }
    
    private var searchButtonView: some View {
        Group {
            if viewStore.isSearchFieldShowing {
                SearchView(store: store.scope(state: { $0.search },
                                              action: { .search($0) }))
                .transition(.move(edge: .leading))
                .frame(width: 256)
            }
            searchButton
        }
    }
    
}

extension BottomBarViewState {
    init(bottomBarState: BottomBarState) {
        self.isSearchFieldShowing = bottomBarState.isSearchFieldShowing
        self.isSearching = bottomBarState.search.isSearching
        self.model = bottomBarState.search.model
        self.displayedView = bottomBarState.search.displayedView
        self.selectedObjectID = bottomBarState.search.selectedObjectID
        self.displayedFavorite = bottomBarState.displayedFavorite
        self.isDownloading = !(bottomBarState.cloudKit.mode?.canStartNewOperation ?? true)
        self.hasLoadedInAppPurchases = bottomBarState.hasLoadedInAppPurchases
        self.displaysAdminFunctionality = bottomBarState.displaysAdminFunctionality
    }
}

extension BottomBarFeatureAction {
    
    @UserDefaultsBacked(key: "last_fetch_date") static var lastFetchDate: Date?
    
    init(_ action: BottomViewAction) {
        switch action {
        case .reset(let displayedView):
            self = .search(.reset(displayedView))
        case .toggleSearchField:
            self = .bottom(.toggleSearchField)
        case .makeRandomSearch:
            self = .search(.makeRandomSearch)
        case .selectView(let view):
            self = .bottom(.selectDisplayedView(view))
        case .search(let objectID):
            self = .search(.makeSearch(Search(id: objectID)))
        case .toggleFavorite:
            self = .bottom(.toggleFavorite)
        case .resetFavoriteResult:
            self = .bottom(.resetFavoriteResult)
        case .refresh:
            self = .cloudKit(.start(date: Self.lastFetchDate))
        case .upload(let model):
            if let performance = model as? PerformanceDisplayModel {
                self = .cloudKit(.uploadPerformance(performance))
            } else if let album = model as? AlbumDisplayModel {
                self = .cloudKit(.uploadAlbum(album))
            } else if let song = model as? SongDisplayModel {
                self = .cloudKit(.uploadSong(song))
            } else {
                fatalError()
            }
        }
    }
}
