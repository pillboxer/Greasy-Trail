import SwiftUI
import UI
import ComposableArchitecture

struct AddAlbumsView: View {
    
    @EnvironmentObject var viewStore: ViewStore<AddState, AddAction>

    private var title: Binding<String> {
        viewStore.binding(get: { $0.albumTitleField },
                          send: { .updateAlbumTitle($0) })
    }
    
    private var date: Binding<Date> {
        viewStore.binding(get: { $0.albumDateField },
                          send: { .updateAlbumDate($0) })
    }
    
    private func bindingForSong(at index: Int) -> Binding<String> {
        return viewStore.binding(get: { state in
            guard index < state.albumSongs.count else {
                return ""
            }
            let song = state.albumSongs[index]
            return song.title
        }, send: { .setAlbumSong(title: $0, index: index) })
    }
    
    var body: some View {
        HStack(alignment: .top) {
            firstColumnView
            secondColumnView
        }
    }
}

extension AddAlbumsView {
    
    private var firstColumnView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("add_album_field_0")
                Spacer()
                Image(systemName: "building.columns.fill")
            }
            Divider().padding(.bottom, 10)
            HStack {
                NSTextFieldRepresentable(placeholder: "", text: title)
                NSDatePickerRepresentable(date: date)
                    .frame(maxWidth: 80)
            }
        }
        .padding()
        .font(.footnote)
    }
    
    private var secondColumnView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("add_album_field_1").font(.footnote)
                    Spacer()
                    PlainOnTapButton(systemImage: "plus.circle") {
                        viewStore.send(.incrAlbumSongCount)
                    }
                }
                Divider().padding(.bottom)
                ForEach(Array(viewStore.albumSongs.enumerated()), id: \.offset) { index, _ in
                    HStack {
                        NSTextFieldRepresentable(placeholder: "add_album_field_1_placeholder",
                                                 text: bindingForSong(at: index),
                                                 textColor: viewStore.albumSongs[index].uuid ==
                            .invalid ? .red : nil)
                        PlainOnTapButton(systemImage: "minus.circle") {
//                            viewStore.send(.removePerformanceSong(at: index))
                        }
                    }
                }
            }
            .padding()
        }
    }
    
}
