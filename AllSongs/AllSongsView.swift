//
//  AllSongsView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

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
    
    let store: Store<SearchState, SearchAction>
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
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { AllSongsState(selectedID: $0.selectedID) },
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
                Spacer()
                    .gesture(doubleTap(objectID: song.objectID))
            }
            TableColumn(LocalizedStringKey("table_column_title_songs_1"),
                        value: \.songAuthor) { song in
                HStack {
                    Text(song.songAuthor)
                    Spacer()
                }
                .contentShape(Rectangle())
                .gesture(doubleTap(objectID: song.objectID))
            }
        }
    }
}

extension AllSongsView: TwoColumnTableViewType {
    
    public func doubleTap(objectID: NSManagedObjectID) -> _EndedGesture<TapGesture> {
        TapGesture(count: 2).onEnded { _ in
            viewStore.send(.search(.init(id: objectID)))
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
