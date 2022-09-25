//
//  AllAlbumsView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import SwiftUI
import GTCoreData
import TwoColumnTable
import GTFormatter

struct AllAlbumsView {
    
    @State var selection: Set<Album.ID> = []
    
    @FetchRequest(entity: Album.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "releaseDate", ascending: false)])
    var fetched: FetchedResults<Album>
    private let formatter = GTFormatter.Formatter()
    
    @State var sortOrder: [KeyPathComparator<Album>] = [
        .init(\.releaseDate, order: SortOrder.reverse),
        .init(\.title, order: SortOrder.forward)
    ]

    var body: some View {
        Table(tableData, selection: $selection, sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_albums_0"), value: \.title!) { album in
                let title = album.title!
                Text(title)
                    .gesture(doubleTap(objectID: album.objectID))
            }
            TableColumn(LocalizedStringKey("table_column_title_albums_1"), value: \.releaseDate) { album in
                Text(formatter.dateString(of: album.releaseDate, in: .full))
                    .gesture(doubleTap(objectID: album.objectID))
            }
        }

    }

}

extension AllAlbumsView: TwoColumnTableViewType {
    func doubleTap(objectID: NSManagedObjectID) -> _EndedGesture<TapGesture> {
        TapGesture().onEnded { _ in
            //
        }
    }
    
    func singleTap(objectIdentifier: String, objectID: NSManagedObjectID) -> _EndedGesture<TapGesture> {
        TapGesture().onEnded { _ in
            //
        }
    }
   
}
