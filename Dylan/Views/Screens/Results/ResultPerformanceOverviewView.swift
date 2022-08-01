//
//  ResultPerformanceOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import SwiftUI

struct ResultPerformanceOverviewView: View {
    
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @State private var presentAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "house")
                    .onTapGesture {
                        searchViewModel.reset()
                    }
                Spacer()
                Text(searchViewModel.performanceModel?.venue ?? "")
                    .font(.headline)
                if let url = searchViewModel.performanceModel?.officialURL() {
                    OnTapButton(systemImage: "globe") {
                        NSWorkspace.shared.open(url)
                    }
                    .buttonStyle(.link)
                }
                Spacer()
            }
            Text(searchViewModel.performanceModel?.date ?? "")
            Spacer()
            HStack {
                SongsListView(songs: searchViewModel.performanceModel?.songs ?? []) { title in
                    searchViewModel.search(.init(title: title, type: .song))
                }
                //                AlbumsListView(albums: searchViewModel.performanceModel?.albums ?? [],
                //                               showingAppearances: true) { title in
                //                    searchViewModel.search(.init(title: title, type: .album))
                //                }
                if let lbNumbers = searchViewModel.performanceModel?.lbNumbers, !lbNumbers.isEmpty {
                    LBsListView(lbs: lbNumbers) { url in
                        NSWorkspace.shared.open(url)
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}
