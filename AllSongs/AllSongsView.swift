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
import TableList

public struct AllSongsView: View {
    
    @ObservedObject var store: Store<TableListState, TableListAction>
    
    @FetchRequest(entity: Song.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)],
                  predicate: NSPredicate(format: "title != %@", "BREAK"))
    public var fetched: FetchedResults<Song>
    
    @State public var sortOrder: [KeyPathComparator<Song>] = [
        .init(\.title, order: SortOrder.forward),
        .init(\.author, order: SortOrder.forward)
    ]
    
    public init(store: Store<TableListState, TableListAction>) {
        self.store = store
    }
    
    public var body: some View {
        Table(tableData, selection: .constant(store.value.ids), sortOrder: $sortOrder) {
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
            store.send(.search(.makeSearch(.init(title: string, type: .song))))
        }
    }
    
    public func singleTap(id: Song.ID) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                store.send(.tableSelect(.select(identifier: id)))
            }
    }
    
}
