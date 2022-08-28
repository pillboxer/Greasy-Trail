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
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<Search?>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = store.scope(value: { $0.failedSearch }, action: { $0 }).view
    }

    public var body: some View {
        if let search = viewStore.value {
            Text(LocalizedStringKey(String(format: NSLocalizedString("search_failed", comment: ""),
                                           search.title)))
            OnTapButton(text: "generic_ok", plainButtonStyle: false) {
                store.send(.reset)
            }
        } else {
            SearchFieldView(store: store)
        }
    }

}
