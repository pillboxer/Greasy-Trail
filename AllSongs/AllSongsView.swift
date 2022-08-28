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
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<Set<ObjectIdentifier>>
    
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
        self.viewStore = store.scope(value: { $0.ids }, action: { $0 }).view
    }
    
    public var body: some View {
        return Table(tableData, selection: .constant(viewStore.value), sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_songs_0"), value: \.title!) { song in
                let title = song.title!
                HStack {
                    Text(title)
                    Spacer()
                }
                .contentShape(Rectangle())
                .gesture(doubleTap(on: title, id: song.id))
                .simultaneousGesture(singleTap(id: song.id))
                
            }
            TableColumn(LocalizedStringKey("table_column_title_songs_1"), value: \.songAuthor) { song in
                let title = song.title!
                HStack {
                    Text(song.songAuthor)
                    Spacer()
                }
                .contentShape(Rectangle())
                .gesture(doubleTap(on: title, id: song.id))
                .simultaneousGesture(singleTap(id: song.id))
            }
        }
    }
    
}

extension AllSongsView: TwoColumnTableViewType {
    
    public func doubleTap(on string: String, id: Song.ID) -> _EndedGesture<TapGesture> {
        TapGesture(count: 2).onEnded { _ in
            store.send(.makeSearch(.init(title: string, type: .song)))
        }
    }
    
    public func singleTap(id: Song.ID) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                store.send(.select(identifier: id))
            }
    }
    
}
