import SwiftUI
import ComposableArchitecture
import UI

struct AddSongView: View {
    
    @EnvironmentObject var viewStore: ViewStore<AddState, AddAction>
    
    private var title: Binding<String> {
        viewStore.binding(get: { $0.songTitleField }, send: { .updateSong(title: $0, author: author.wrappedValue) })
    }
    
    private var author: Binding<String> {
        viewStore.binding(get: { $0.songAuthorField }, send: { .updateSong(title: title.wrappedValue, author: $0) })
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("add_song_field_0").font(.footnote)
                        if let uuid = viewStore.songUUID, uuid != "" {
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .frame(width: 8, height: 8)
                        }
                    }
                    NSTextFieldRepresentable(placeholder: "", text: title)
                }
                VStack(alignment: .leading) {
                    Text("add_song_field_1").font(.footnote)
                    NSTextFieldRepresentable(placeholder: "", text: author)
                }
                Spacer()
            }
            .frame(width: 256)
            .padding()
            Spacer()
        }
    }
}
