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

public struct BottomBarView: View {

    let store: Store<BottomBarState, BottomBarFeatureAction>
    @ObservedObject private var viewStore: ViewStore<BottomBarViewState, BottomViewAction>
    
    public init(store: Store<BottomBarState, BottomBarFeatureAction>) {
        self.store = store
        self.viewStore = store.scope(value: BottomBarViewState.init,
                                     action: BottomBarFeatureAction.init).view
    }
    
    public var body: some View {
        HStack {
            if viewStore.value.model != nil {
                OnTapButton(systemImage: "house") {
                    withAnimation {
                        viewStore.send(.reset)
                    }
                }
                .help("bottom_bar_tooltip_house")
            }
            if viewStore.value.isSearchFieldShowing {
                SearchView(store: store.scope(value: { $0.searchState }, action: { .search($0) })) 
                    .transition(.move(edge: .leading))
            }
            OnTapButton(systemImage: "magnifyingglass") {
                withAnimation {
                    viewStore.send(.toggleSearchField)
                }
            }
            .help("bottom_bar_tooltip_search")
            OnTapButton(systemImage: "dice") {
                viewStore.send(.makeRandomSearch)
            }
            .help("bottom_bar_tooltip_random")
            Spacer()
            if viewStore.value.isSearching {
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
    init(bottomBarViewState: BottomBarState) {
        self.isSearchFieldShowing = bottomBarViewState.isSearchFieldShowing
        self.isSearching = bottomBarViewState.searchState.isSearching
        self.model = bottomBarViewState.model
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
        }
    }
}
