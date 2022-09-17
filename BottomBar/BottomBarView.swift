import SwiftUI
import ComposableArchitecture
import UI
import SearchField
import GTCloudKit
import Core
import Search
import Model

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
            case .add:
                closeAddButton
                Spacer()
                songButton
                albumButton
                performanceButton
                Spacer()
                uploadButton
            case .result:
                homeButton
                randomButton
                Spacer()
            default:
               homeView
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
    
    @ViewBuilder
    var homeView: some View {
        if viewStore.model != nil {
            homeButton
        }
        if viewStore.selectedObjectID != nil {
            editButton
        }
        if viewStore.isSearchFieldShowing {
            SearchView(store: store.scope(state: { $0.search },
                                          action: { .search($0) }))
            .transition(.move(edge: .leading))
        }
        searchButton
        randomButton
        openAddButton
        Spacer()
        recordButtons
    }
}

extension BottomBarView {

    @ViewBuilder
    var recordButtons: some View {
        songButton
        albumButton
        performanceButton
    }
    
}

extension BottomBarViewState {
    init(bottomBarState: BottomBarState) {
        self.isSearchFieldShowing = bottomBarState.isSearchFieldShowing
        self.isSearching = bottomBarState.search.isSearching
        self.model = bottomBarState.search.model
        self.displayedView = bottomBarState.search.displayedView
        self.selectedRecordToAdd = bottomBarState.selectedRecordToAdd
        self.selectedObjectID = bottomBarState.search.selectedObjectID
    }
}

extension BottomBarFeatureAction {
    init(_ action: BottomViewAction) {
        switch action {
        case .reset:
            self = .search(.reset)
        case .toggleSearchField:
            self = .bottom(.toggleSearchField)
        case .makeRandomSearch:
            self = .search(.makeRandomSearch)
        case .selectView(let view):
            self = .bottom(.selectDisplayedView(view))
        case .selectRecordToAdd(let record):
            self = .bottom(.selectRecordToAdd(record))
        case .search(let objectID):
            self = .search(.makeSearch(Search(id: objectID)))
        case .upload(let model):
            if let performance = model as? PerformanceDisplayModel {
                self = .cloudKit(.uploadPerformance(performance))
            } else {
                fatalError()
            }
        }
    }
}
