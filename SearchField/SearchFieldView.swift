//
//  SearchFieldView.swift
//  Dylan
//
//  Created by Henry Cooper on 04/07/2022.
//

import SwiftUI
import UI
import ComposableArchitecture
import Search
import Model

struct SearchFieldView: View {
    
    fileprivate enum SearchFieldAction {
        case search(Search)
        case setText(String)
    }
    
    private struct SearchFieldState: Equatable {
        var searchFieldText: String
    }
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<SearchFieldState, SearchFieldAction>
    
    private var textBinding: Binding<String> {
        return viewStore.binding(get: { $0.searchFieldText },
                                 send: { SearchFieldAction.setText($0) })
    }
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { SearchFieldState(searchFieldText: $0.searchFieldText) },
                                     action: SearchAction.init))
    }
    
    var body: some View {
            NSTextFieldRepresentable(placeholder: "search_placeholder", text: textBinding) {
                search()
            }
            .frame(maxWidth: 250)
            .padding(4)
    }
    
    private func search() {
        let search = Search(title: textBinding.wrappedValue, type: nil)
        viewStore.send(.search(search))
    }
}

fileprivate extension SearchAction {
    
    init(action: SearchFieldView.SearchFieldAction) {
        switch action {
        case .search(let search):
            self = .makeSearch(search)
        case .setText(let string):
            self = .setSearchFieldText(string)
        }
    }
}
