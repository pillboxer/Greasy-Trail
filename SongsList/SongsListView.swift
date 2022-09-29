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
            Text("songs_list_title").font(.headline)
                .underline()
                .padding(.bottom, 8)
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(songs, id: \.self) { song in
                        HStack {
                            let index = (songs.firstIndex(of: song) ?? 0)
                            ListSongView(index: index, title: song.title, author: song.author, onTap: {
                                onTap(song.baseSongUUID ?? song.title)
                            })
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
