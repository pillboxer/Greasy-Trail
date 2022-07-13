//
//  SongListView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 13/07/2022.
//

import SwiftUI

struct SongsListView: View {
    
    let songs: [sSong]
    private var titles: [String] {
        songs.map { $0.title }
    }
    let onTap: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Songs").font(.title)
                .padding(.bottom)
            ScrollView {
                ForEach(songs, id: \.self) { song in
                    let title = song.title
                    let index = titles.firstIndex(of: title) ?? 0
                    HStack(alignment: .top) {
                        Text("\(index + 1).")
                        ListRowView(headline: title, subHeadline: song.author) {
                            onTap(title)
                        }
                    }
                    .padding(2)
                }
            }
        }
    }
}

