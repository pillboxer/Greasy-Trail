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
                let index = (songs.firstIndex(of: song) ?? 0)
                ListSongView(index: index, title: song.title, author: song.author, onTap: {
                    onTap(song.title)
                }, onButtonTap: { button in
                    print(button.rawValue)
                })
                .padding(2)
            }
        }
    }
}
