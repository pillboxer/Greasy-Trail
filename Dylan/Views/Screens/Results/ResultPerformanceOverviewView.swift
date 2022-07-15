//
//  ResultPerformanceOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import SwiftUI

struct ResultPerformanceOverviewView: View {
    
    @Binding var model: PerformanceDisplayModel?
    @Binding var nextSearch: Search?
    @Binding var currentViewType: ResultView.ResultViewType
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "house")
                    .onTapGesture {
                        model = nil
                    }
                Spacer()
                Text(model?.venue ?? "")
                    .font(.headline)
                if let url = model?.officialURL() {
                    OnTapButton(systemImage: "globe") {
                        NSWorkspace.shared.open(url)
                    }
                    .buttonStyle(.link)
                }
                Spacer()
            }
            Spacer()
            HStack {
                SongsListView(songs: model?.songs ?? []) { title in
                    nextSearch = Search(title: title, type: .song)
                    model = nil
                }
                AlbumsListView(albums: model?.albums ?? [], showingAppearances: true) { title in
                    nextSearch = Search(title: title, type: .album)
                    model = nil
                }
                if let lbNumbers = model?.lbNumbers {
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
