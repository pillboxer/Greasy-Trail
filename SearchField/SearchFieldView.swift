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

public struct SearchFieldView: View {
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject var viewStore: ViewStore<Search?>
    @State private var text = ""
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = store.scope(value: { $0.currentSearch }, action: { $0 }).view(id: "SEARCH FIELD")
    }

   public var body: some View {
       if viewStore.value != nil {
           ProgressView("searching_progress")
        } else {
            HStack {
                OnTapButton(systemImage: "arrow.clockwise") {
                    // FIXME: refresh
                }
                .buttonStyle(.plain)
                NSTextFieldRepresentable(placeholder: "search_placeholder", text: $text) {
                    search()
                }
                .frame(maxWidth: 250)
                OnTapButton(systemImage: "magnifyingglass.circle") {
                    search()
                }
                .buttonStyle(.plain)
            }
            .padding(4)
        }
    }
    
    private func search() {
        let search = Search(title: text, type: nil)
        store.send(.makeSearch(search))
    }
}
