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
    
    private struct SearchViewState: Equatable {
        var search: Search?
    }
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<SearchViewState, SearchViewAction>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = store.scope(value: { SearchViewState(search: $0.failedSearch) },
                                     action: SearchAction.init).view
    }

    public var body: some View {
        if let search = viewStore.search {
            Text(LocalizedStringKey(String(format: NSLocalizedString("search_failed", comment: ""),
                                           search.title ?? "")))
            OnTapButton(text: "generic_ok", plainButtonStyle: false) {
                viewStore.send(.reset)
            }
        } else {
            SearchFieldView(store: store)
        }
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
