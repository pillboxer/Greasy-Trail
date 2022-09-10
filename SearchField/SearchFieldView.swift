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
    }
    
    private struct SearchFieldState: Equatable {}
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private  var viewStore: ViewStore<SearchFieldState, SearchFieldAction>
    @State private var text = ""
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { _ in SearchFieldState() },
                                     action: SearchAction.init))
    }
    
    var body: some View {
        HStack {
            NSTextFieldRepresentable(placeholder: "search_placeholder", text: $text) {
                search()
            }
            .frame(maxWidth: 250)
            
        }
        .padding(4)
    }
    
    private func search() {
        let search = Search(title: text, type: nil)
        text = ""
        viewStore.send(.search(search))
    }
}

fileprivate extension SearchAction {
    
    init(action: SearchFieldView.SearchFieldAction) {
        switch action {
        case .search(let search):
            self = .makeSearch(search)
        }
    }
}
