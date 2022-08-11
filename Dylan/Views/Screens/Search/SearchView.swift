//
//  SearchView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI
import UI
import SearchField
import Search
import ComposableArchitecture

struct SearchView: View {
    
    @ObservedObject var store: Store<SearchState, SearchAction>

    var body: some View {
        if let search = store.value.failedSearch {
            Text(LocalizedStringKey(String(format: NSLocalizedString("search_failed", comment: ""),
                                           search.title)))
            OnTapButton(text: "generic_ok") {
                store.send(.reset)
            }
        } else {
            SearchFieldView(store: store)
        }
    }

}
