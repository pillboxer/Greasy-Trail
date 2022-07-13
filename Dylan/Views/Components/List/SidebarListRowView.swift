//
//  ListRowView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import SwiftUI

struct SidebarListRowView: View {

    @EnvironmentObject var viewModel: NavigationViewModel
    
    @State var selection: String
    @Binding var nextSearch: Search?

    var body: some View {
        NavigationLink(destination: destinationFor(selection), tag: selection, selection: $viewModel.selectedID) {
            Text(selection.capitalized)
                .font(.headline)
        }
    }
    
    @ViewBuilder
    func destinationFor(_ selection: String) -> some View {
        if let section = NavigationViewModel.NavigationSection(rawValue: selection) {
            switch section {
            case .songs:
                AllSongsView(nextSearch: $nextSearch)
            case .albums:
                AllAlbumsView(nextSearch: $nextSearch)
            case .performances:
                AllPerformancesView(nextSearch: $nextSearch)
            }
        }
        else {
            fatalError()
        }
    }
}