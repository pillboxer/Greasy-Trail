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

    let store: Store<BottomBarFeatureState, BottomBarFeatureAction>
    @ObservedObject private var viewStore: ViewStore<BottomBarState>
    
    public init(store: Store<BottomBarFeatureState, BottomBarFeatureAction>) {
        self.store = store
        self.viewStore = store.scope(value: {
            BottomBarState(isSearchFieldShowing: $0.bottomBarState.isSearchFieldShowing,
                           isSearching: $0.searchState.isSearching,
                           model: $0.model)},
                                     action: { $0 }).view }
    
    public var body: some View {
        HStack {
            if viewStore.value.model != nil {
                OnTapButton(systemImage: "house") {
                    store.send(.search(.reset))
                }
                
            }
            if viewStore.value.isSearchFieldShowing {
                SearchView(store: store.scope(value: { $0.searchState }, action: { .search($0) })) 
                    .transition(.move(edge: .leading))
            }
            OnTapButton(systemImage: "magnifyingglass") {
                withAnimation {
                    store.send(.bottom(.toggleSearchField))
                }
            }
            .help("bottom_bar_tooltip_1")
            
            OnTapButton(systemImage: "dice") {
                store.send(.search(.makeRandomSearch))
            }
            
            .help("bottom_bar_tooltip_0")
            Spacer()
            if viewStore.value.isSearching {
                ProgressView()
                    .scaleEffect(0.4)
            }
            
        }
        .padding()
        .frame(maxHeight: 36)
    }
}
