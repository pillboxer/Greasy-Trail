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

    var titlesWithoutBreaks: [sSong] {
        songs.filter { $0.title != "BREAK" }
    }
    let onTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("songs_list_title").font(.title)
                .padding(.bottom)
            ScrollView {
                ForEach(songs, id: \.self) { song in
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
}
