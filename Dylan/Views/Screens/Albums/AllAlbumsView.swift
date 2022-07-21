//
//  AllAlbumsView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import SwiftUI

struct AllAlbumsView {

    @Binding var nextSearch: Search?
    @State var selection: Set<Album.ID> = []
    @FetchRequest(entity: Album.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "releaseDate", ascending: false)])
    var fetched: FetchedResults<Album>
    private let formatter = Formatter()
    @State var sortOrder: [KeyPathComparator<Album>] = [
        .init(\.releaseDate, order: SortOrder.reverse),
        .init(\.title, order: SortOrder.forward)
    ]

    var body: some View {

        Table(tableData, selection: $selection, sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_albums_0"), value: \.title!) { album in
                let title = album.title!
                Text(title)
                    .gesture(doubleTap(on: title, id: album.id))
                    .simultaneousGesture(singleTap(id: album.id))
            }
            TableColumn(LocalizedStringKey("table_column_title_albums_1"), value: \.releaseDate) { album in
                let title = album.title!
                Text(formatter.dateString(of: album.releaseDate))
                    .gesture(doubleTap(on: title, id: album.id))
                    .simultaneousGesture(singleTap(id: album.id))
            }
        }

    }

}

extension AllAlbumsView: TwoColumnTableViewType {

    func doubleTap(on string: String, id: Album.ID) -> _EndedGesture<TapGesture> {
        TapGesture(count: 2).onEnded { _ in
            selection.removeAll()
            nextSearch = Search(title: string, type: .album)
            selection.insert(id)
        }
    }

    func singleTap(id: Album.ID) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                selection.removeAll()
                selection.insert(id)
            }
    }

}
