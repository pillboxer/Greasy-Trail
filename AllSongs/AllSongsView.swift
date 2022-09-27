import SwiftUI
import GTCoreData
import TwoColumnTable
import ComposableArchitecture
import Search
import UI

public struct AllSongsView: TableViewType {
    
    let store: Store<AllSongsState, AllSongsFeatureAction>
    @ObservedObject private var viewStore: ViewStore<AllSongsState, AllSongsViewAction>
    
    @State public var sortOrder: [KeyPathComparator<Song>] = [
        .init(\.title, order: SortOrder.forward),
        .init(\.author, order: SortOrder.forward)
    ]
    @FetchRequest(entity: Song.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)],
                  predicate: NSPredicate(format: "title != %@", "BREAK"))
    public var fetched: FetchedResults<Song>
    
    private func toggleBinding(on song: Song) -> Binding<Bool> {
        let ids = idsOnToggle(on: song)
        return viewStore.binding(get: { $0.selectedID == song.id },
                                 send: .select(objectIdentifier: ids.0,
                                               id: ids.1))
    }
    
    public init(store: Store<AllSongsState, AllSongsFeatureAction>, predicate: NSPredicate) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { $0 }, action: AllSongsFeatureAction.init))
        _fetched = FetchRequest<Song>(entity: Song.entity(),
                                             sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)],
                                             predicate: predicate)
    }
    
    public var body: some View {
        VStack {
            Text("songs_list_title")
                .underline()
                .font(.headline)
                .padding(.top)
            HStack {
                ForEach(SongPredicate.allCases, id: \.rawValue) { predicate in
                    PlainOnTapButton(text: predicate.rawValue) {
                        let predicate = SongPredicate(rawValue: predicate.rawValue)!
                        viewStore.send(.selectSongPredicate(predicate))
                    }
                    .font(.caption.weight(predicate == viewStore.state.selectedSongPredicate ? .bold : .regular))
                }
            }
            .frame(height: 32)
            Table(tableData, sortOrder: $sortOrder) {
                TableColumn(LocalizedStringKey("table_column_title_songs_0"),
                            value: \.title!) { song in
                    let title = song.title!
                    Toggle(isOn: toggleBinding(on: song)) {
                        Text(title)
                            .padding(.leading, 4)
                    }
                    .padding(.top, 4)
                    .toggleStyle(CheckboxToggleStyle())
                }
                TableColumn(LocalizedStringKey("table_column_title_songs_1"),
                            value: \.songAuthor) { song in
                    HStack {
                        Text(song.songAuthor)
                        Spacer()
                        PlainOnTapButton(systemImage: "chevron.right.circle") {
                            viewStore.send(.search(.init(id: song.objectID)))
                        }
                    }
                    .contentShape(Rectangle())
                }
            }
        }
    }
}

private extension AllSongsView {
    
    func idsOnToggle(on song: Song) -> (objectIdentifier: ObjectIdentifier?,
                                        objectID: NSManagedObjectID?) {
        if viewStore.selectedID == song.id {
            return (nil, nil)
        }
        return (song.id, song.objectID)
    }
    
}

fileprivate extension AllSongsFeatureAction {
    
    init(action: AllSongsViewAction) {
        switch action {
        case .search(let search):
            self = .search(.makeSearch(search))
        case .selectID(let objectIdentifier):
            self = .search(.selectID(objectIdentifier: objectIdentifier))
        case .select(objectIdentifier: let objectIdentifier, id: let id):
            self = .search(.select(objectIdentifier: objectIdentifier, objectID: id))
        case .selectSongPredicate(let predicate):
            self = .allSongs(.selectSongPredicate(predicate))
        }
    }
}
