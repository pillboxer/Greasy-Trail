//
//  AllSongsView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import SwiftUI

struct AllSongsView: View {
    
    @Binding var nextSearch: Search?
    @State var selection: Set<Song.ID> = []
    @FetchRequest(entity: Song.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: NSPredicate(format: "title != %@", "BREAK")) var fetched: FetchedResults<Song>

    @State var sortOrder: [KeyPathComparator<Song>] = [
            .init(\.title, order: SortOrder.forward),
            .init(\.author, order: SortOrder.forward)
        ]
    
    var body: some View {
        
        Table(tableData, selection: $selection, sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_songs_0")) { song in
                let title = song.title!
                Text(title)
                    .gesture(doubleTap(on: title, id: song.id))
                    .simultaneousGesture(singleTap(id: title))
            }
            TableColumn(LocalizedStringKey("table_column_title_songs_1")) { song in
                let title = song.title!
                Text(song.author ?? "Bob Dylan")
                    .gesture(doubleTap(on: title, id: song.id))
                    .simultaneousGesture(singleTap(id: title))
            }
        }
        
    }
    
}

extension AllSongsView: TwoColumnTableViewType {
    
    func doubleTap(on string: String, id: Song.ID) -> _EndedGesture<TapGesture> {
        TapGesture(count: 2).onEnded { _ in
            selection.removeAll()
            nextSearch = Search(title: string, type: .song)
            selection.insert(id)
        }
    }
    
    func singleTap(id: Song.ID) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                selection.removeAll()
                selection.insert(id)
            }
    }
    
    var tableData: [Song] {
        return fetched.sorted(using: sortOrder)
    }
    
}

