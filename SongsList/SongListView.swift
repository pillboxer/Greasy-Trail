//
//  SongListView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 13/07/2022.
//

import SwiftUI
import Model
import UI

public struct SongsListView: View {
    
    let songs: [sSong]
    let onTap: (String) -> Void
    
    public init(songs: [sSong], onTap: @escaping (String) -> Void) {
        self.songs = songs
        self.onTap = onTap
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("songs_list_title").font(.title)
                .padding(.bottom)
            List(songs, id: \.self) { song in
                let title = song.title
                if title == "BREAK" {
                    Divider()
                } else {
                    let index = (titlesWithoutBreaks.firstIndex(of: song) ?? 0)
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

private extension SongsListView {
    
    var titles: [String] {
        songs.map { $0.title }
    }
    
    var titlesWithoutBreaks: [sSong] {
        songs.filter { $0.title != "BREAK" }
    }
    
}
