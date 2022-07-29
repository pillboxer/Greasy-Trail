//
//  SearchView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

// Rename
enum DylanSearchType {
    case song
    case album
    case performance
}

struct SearchView: View {

    @EnvironmentObject var searchViewModel: SearchViewModel

    var body: some View {
        if searchViewModel.shouldDisplayNoResultsFound {
            Text(LocalizedStringKey(String(format: NSLocalizedString("search_failed", comment: ""),
                                           searchViewModel.text)))
            OnTapButton(text: "generic_ok") {
                searchViewModel.reset()
            }
        } else {
            SearchFieldView()
        }
    }

}
