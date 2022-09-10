//
//  BottomBarView.swift
//  BottomBar
//
//  Created by Henry Cooper on 28/08/2022.
//

import SwiftUI
import ComposableArchitecture
import UI
import SearchField
import Search

public enum BottomBarSection {
    case home
    case add
}

public struct BottomBarView: View {

    let store: Store<BottomBarState, BottomBarFeatureAction>
    @ObservedObject var viewStore: ViewStore<BottomBarViewState, BottomViewAction>
    
    public init(store: Store<BottomBarState, BottomBarFeatureAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: BottomBarViewState.init, action: BottomBarFeatureAction.init))
    }
    
    public var body: some View {
        HStack {
            switch viewStore.selectedSection {
            case .add:
                closeAddButton
                Spacer()
                songButton
                albumButton
                performanceButton
                Spacer()
                uploadButton
            case .home:
                if viewStore.model != nil {
                    homeButton
                }
                if viewStore.selectedObjectID != nil {
                    editButton
                }
                if viewStore.isSearchFieldShowing {
                    SearchView(store: store.scope(state: { $0.searchState },
                                                  action: { .search($0) }))
                        .transition(.move(edge: .leading))
                }
                searchButton
                randomButton
                openAddButton
                Spacer()
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

extension BottomBarViewState {
    init(bottomBarState: BottomBarState) {
        self.isSearchFieldShowing = bottomBarState.isSearchFieldShowing
        self.isSearching = bottomBarState.searchState.isSearching
        self.model = bottomBarState.model
        self.selectedSection = bottomBarState.selectedSection
        self.selectedRecordToAdd = bottomBarState.selectedRecordToAdd
        self.selectedObjectID = bottomBarState.selectedObjectID
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
        case .selectSection(let section):
            self = .bottom(.selectSection(section))
        case .selectRecordToAdd(let record):
            self = .bottom(.selectRecordToAdd(record))
        case .search(let objectID):
            self = .search(.makeSearch(Search(id: objectID)))
        }
    }
}
