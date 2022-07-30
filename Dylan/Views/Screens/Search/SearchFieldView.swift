//
//  SearchFieldView.swift
//  Dylan
//
//  Created by Henry Cooper on 04/07/2022.
//

import SwiftUI

struct SearchFieldView: View {

    @EnvironmentObject private var searchViewModel: SearchViewModel

    var body: some View {
        if searchViewModel.shouldDisplaySearch {
            SearchingView()
        } else {
            HStack {
                OnTapButton(systemImage: "arrow.clockwise") {
                    searchViewModel.refresh()
                }
                .buttonStyle(.plain)
                NSTextFieldRepresentable(placeholder: "search_placeholder", text: $searchViewModel.text) {
                    searchViewModel.searchBlind()
                }
                .frame(maxWidth: 250)
                OnTapButton(systemImage: "magnifyingglass.circle") {
                    searchViewModel.searchBlind()
                }
                .buttonStyle(.plain)
            }
            .padding(4)
        }
    }
}
