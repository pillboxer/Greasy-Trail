import SwiftUI
import GTCoreData
import TwoColumnTable
import GTFormatter
import ComposableArchitecture
import UI

public struct AllAlbumsView: TableViewType {
    
    private let store: Store<AllAlbumsState, AllAlbumsFeatureAction>
    private let formatter = GTFormatter.Formatter()
    private let predicate: NSPredicate
    @ObservedObject private var viewStore: ViewStore<AllAlbumsViewState, AllAlbumsViewAction>
    
    @FetchRequest public var fetched: FetchedResults<Album>
    
    @State public var sortOrder: [KeyPathComparator<Album>] = [
        .init(\.releaseDate, order: SortOrder.reverse),
        .init(\.title, order: SortOrder.forward)
    ]
    
    private func toggleBinding(on album: Album) -> Binding<Bool> {
        let ids = idsOnToggle(on: album)
        return viewStore.binding(get: { $0.selectedID == album.id },
                                 send: .select(
                                    objectIdentifier: ids.0,
                                    id: ids.1))
    }
    
    public init(store: Store<AllAlbumsState, AllAlbumsFeatureAction>,
                predicate: NSPredicate = NSPredicate(value: true)) {
        self.store = store
        self.predicate = predicate
        self.viewStore = ViewStore(store.scope(state: {
            AllAlbumsViewState(
                selectedID: $0.search.selectedID,
                selectedPredicate: $0.albumPredicate,
                displaysAdminFunctionality: $0.displaysAdminFunctionality)
        }, action: AllAlbumsFeatureAction.init))
        _fetched = FetchRequest<Album>(
            entity: Album.entity(),
            sortDescriptors: [NSSortDescriptor(key: "releaseDate", ascending: false)],
            predicate: predicate)
    }
    
    public var body: some View {
        VStack {
            Text("albums_list_title")
                .underline()
                .font(.headline)
                .padding(.top)
            HStack {
                ForEach(AlbumPredicate.allCases, id: \.rawValue) { predicate in
                    PlainOnTapButton(text: predicate.rawValue) {
                        let predicate = AlbumPredicate(rawValue: predicate.rawValue)!
                        viewStore.send(.selectAlbumPredicate(predicate))
                    }
                    .font(.caption.weight(predicate == viewStore.state.selectedPredicate ? .bold : .regular))
                }
            }
            .frame(height: 32)
            Table(tableData, sortOrder: $sortOrder) {
                TableColumn(LocalizedStringKey("table_column_title_albums_0"),
                            value: \.title!) { album in
                    let title = album.title!
                    if viewStore.displaysAdminFunctionality {
                    Toggle(isOn: toggleBinding(on: album)) {
                        Text(title)
                            .padding(.leading, 4)
                    }
                    .padding(.top, 4)
                    .toggleStyle(CheckboxToggleStyle())
                    } else {
                        Text(title)
                    }
                }
                TableColumn(LocalizedStringKey("table_column_title_albums_1"),
                            value: \.releaseDate) { album in
                    HStack {
                        Text(formatter.dateString(of: album.releaseDate, in: .full))
                        Spacer()
                        PlainOnTapButton(systemImage: "chevron.right.circle") {
                            viewStore.send(.search(.init(id: album.objectID)))
                        }
                    }
                }
            }
        }
    }
}

private extension AllAlbumsView {
    
    func idsOnToggle(on album: Album) -> (objectIdentifier: ObjectIdentifier?,
                                        objectID: NSManagedObjectID?) {
        if viewStore.selectedID == album.id {
            return (nil, nil)
        }
        return (album.id, album.objectID)
    }
    
}

fileprivate extension AllAlbumsFeatureAction {
    
    init(action: AllAlbumsViewAction) {
        switch action {
        case .search(let search):
            self = .search(.makeSearch(search))
        case .selectID(let objectIdentifier):
            self = .search(.selectID(objectIdentifier: objectIdentifier))
        case .select(objectIdentifier: let objectIdentifier, id: let id):
            self = .search(.select(objectIdentifier: objectIdentifier, objectID: id))
        case .selectAlbumPredicate(let predicate):
            self = .allAlbums(.selectAlbumPredicate(predicate))
        }
    }
}
