import SwiftUI
import ComposableArchitecture
import UI

struct AddSongView: View {
    
    @EnvironmentObject var viewStore: ViewStore<AddState, AddAction>
    
    private var title: Binding<String> {
        viewStore.binding(get: { $0.songTitleField },
                          send: { .updateSong(title: $0,
                                              author: author.wrappedValue,
                                              baseSongTitle: baseSongTitle.wrappedValue)
        })
    }
    
    private var author: Binding<String> {
        viewStore.binding(get: { $0.songAuthorField },
                          send: { .updateSong(title: title.wrappedValue,
                                              author: $0,
                                              baseSongTitle: baseSongTitle.wrappedValue)
        })
    }
    
    private var baseSongTitle: Binding<String> {
        viewStore.binding(get: { $0.baseSongTitle },
                          send: { .updateSong(title: title.wrappedValue,
                                              author: author.wrappedValue,
                                              baseSongTitle: $0)
        })
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("add_song_field_0").font(.footnote)
                    }
                    NSTextFieldRepresentable(placeholder: "", text: title)
                }
                Text("add_song_field_1").font(.footnote)
                NSTextFieldRepresentable(placeholder: "", text: author)
                Text("add_song_field_2").font(.footnote)
                NSTextFieldRepresentable(placeholder: "", text: baseSongTitle,
                                         textColor: viewStore.isInvalidBaseSongUUID ? .red : nil)
                Spacer()
            }
            .frame(width: 320)
            .padding()
            Spacer()
        }
    }
}
