//
//  AlbumsListView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 13/07/2022.
//

import SwiftUI
import Model
import GTFormatter
import UI
struct AlbumsListView: View {

    let albums: [sAlbum]
    var showingAppearances: Bool = false
    private var titles: [String] {
        albums.map { $0.title }
    }
    
    private var uniqueAlbums: [sAlbum] {
        Array(Set(albums)).sorted { $0.releaseDate < $1.releaseDate }
    }
    
    let onTap: (String) -> Void
    private let formatter = GTFormatter.Formatter()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("albums_list_title").font(.title)
                .padding(.bottom)
            List(uniqueAlbums, id: \.self) { album in
                let appearances = albums.filter { $0.title == album.title }.count
                let prefix = album.title
                let suffix = showingAppearances ? "(\(String(appearances)))" : ""
                let title = "\(prefix) \(suffix)"
                HStack(alignment: .top) {
                    ListRowView(headline: title, subheadline: formatter.dateString(of: album.releaseDate)) {
                        onTap(album.title)
                    }
                }
                .padding(2)
            }   
        }
    }
}
