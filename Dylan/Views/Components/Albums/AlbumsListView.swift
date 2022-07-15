//
//  AlbumsListView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 13/07/2022.
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
