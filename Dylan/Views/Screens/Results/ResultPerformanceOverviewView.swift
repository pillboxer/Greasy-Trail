//
//  ResultPerformanceOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import SwiftUI

struct AlbumsListView: View {
    
    let albums: [sAlbum]
    private var titles: [String] {
        albums.map { $0.title }
    }
        
    private var uniqueAlbums: [sAlbum] {
        Array(Set(albums))
    }
    
    
    let onTap: (String) -> Void
    private let formatter = Formatter()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Albums").font(.title)
                .padding(.bottom)
            ScrollView {
                ForEach(uniqueAlbums, id: \.self) { album in
                    let appearances = albums.filter { $0.title == album.title }.count
                    let title = "\(album.title) (\(appearances))"
                    HStack(alignment: .top) {
                        ListRowView(headline: title, subHeadline: formatter.dateString(of: album.releaseDate)) {
                            onTap(album.title)
                        }
                    }
                    .padding(2)
                }
            }
        }
    }
}

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
                AlbumsListView(albums: model?.albums ?? []) { title in
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

            HStack {
    
                Spacer()
  
            }

        }
        .padding()
    }
    
}
