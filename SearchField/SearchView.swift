//
//  SearchView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI
import UI
import Search
import ComposableArchitecture

public struct SearchView: View {
    
    fileprivate enum SearchViewAction {
        case reset
    }
    
    private struct SearchViewState: Equatable {    }
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<Void, SearchViewAction>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = ViewStore(store.stateless.scope(state: { _ in ()},
                                     action: SearchAction.init))
    }

    public var body: some View {
        SearchFieldView(store: store)
    }

}

fileprivate extension SearchAction {
    
    init(action: SearchView.SearchViewAction) {
        switch action {
        case .reset:
            self = .reset
        }
    }
}
