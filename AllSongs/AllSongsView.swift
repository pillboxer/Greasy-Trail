import SwiftUI
import GTCoreData
import TwoColumnTable
import ComposableArchitecture
import Search
import UI

public struct AllSongsView: View {
    
    fileprivate enum AllSongsAction {
        case search(Search)
        case selectID(objectIdentifier: ObjectIdentifier?)
        case select(objectIdentifier: ObjectIdentifier?, id: NSManagedObjectID?)
    }
    
    private struct AllSongsState: Equatable {
        var selectedID: ObjectIdentifier?
    }
    
    let store: Store<ObjectIdentifier?, SearchAction>
    @ObservedObject private var viewStore: ViewStore<AllSongsState, AllSongsAction>
    
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
    
    public init(store: Store<ObjectIdentifier?, SearchAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { AllSongsState(selectedID: $0) },
                                               action: SearchAction.init))
    }
    
    public var body: some View {
        
        return Table(tableData, sortOrder: $sortOrder) {
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

extension AllSongsView: TwoColumnTableViewType {}

private extension AllSongsView {
    
    func idsOnToggle(on song: Song) -> (objectIdentifier: ObjectIdentifier?,
                                        objectID: NSManagedObjectID?) {
        if viewStore.selectedID == song.id {
            return (nil, nil)
        }
        return (song.id, song.objectID)
    }
    
}

fileprivate extension SearchAction {
    
    init(action: AllSongsView.AllSongsAction) {
        switch action {
        case .search(let search):
            self = .makeSearch(search)
        case .selectID(let objectIdentifier):
            self = .selectID(objectIdentifier: objectIdentifier)
        case .select(objectIdentifier: let objectIdentifier, id: let id):
            self = .select(objectIdentifier: objectIdentifier, objectID: id)
        }
    }
}
