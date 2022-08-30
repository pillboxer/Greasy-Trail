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

public struct AllSongsView: View {
    
    fileprivate enum AllSongsAction {
        case search(Search)
        case selectID(objectIdentifier: ObjectIdentifier?)
        case select(objectIdentifier: ObjectIdentifier, id: NSManagedObjectID)
    }
    
    private struct AllSongsState: Equatable {
        var selectedID: ObjectIdentifier?
    }
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<AllSongsState, AllSongsAction>
    
    @FetchRequest(entity: Song.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)],
                  predicate: NSPredicate(format: "title != %@", "BREAK"))
    public var fetched: FetchedResults<Song>
    
    @State public var sortOrder: [KeyPathComparator<Song>] = [
        .init(\.title, order: SortOrder.forward),
        .init(\.author, order: SortOrder.forward)
    ]
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = store.scope(value: { AllSongsState(selectedID: $0.selectedID) },
                                     action: SearchAction.init).view
    }
    
    public var body: some View {
        
        return Table(tableData,
                     selection: viewStore.binding(get: \.selectedID,
                                                  send: { .selectID(objectIdentifier: $0) }),
                     sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_songs_0"),
                        value: \.title!) { song in
                
                let title = song.title!
                HStack {
                    Text(title)
                    Spacer()
                }
                .contentShape(Rectangle())
                .gesture(doubleTap(objectID: song.objectID))
                .simultaneousGesture(singleTap(objectIdentifier: song.id, objectID: song.objectID))
                
            }
            
            TableColumn(LocalizedStringKey("table_column_title_songs_1"),
                        value: \.songAuthor) { song in
                HStack {
                    Text(song.songAuthor)
                    Spacer()
                }
                .contentShape(Rectangle())
                .gesture(doubleTap(objectID: song.objectID))
                .simultaneousGesture(singleTap(objectIdentifier: song.id, objectID: song.objectID))
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
    
    public func singleTap(objectIdentifier: Song.ID, objectID: NSManagedObjectID) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                viewStore.send(.select(objectIdentifier: objectIdentifier, id: objectID))
            }
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
