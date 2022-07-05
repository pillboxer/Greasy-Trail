//
//  ResultAlbumsTableView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI
 
/// Shows table of albums that a given song appears on
struct ResultAlbumsTableView: View {
    
    let albums: [Album]
    @Binding var model: SongDisplayModel?
    @EnvironmentObject var formatter: Formatter
    @Binding var nextSearch: Search?
    @Binding var currentViewType: ResultView.ResultViewType
    @State private var selection: Album.ID?
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .onTapGesture {
                        currentViewType = .songOverview
                    }
                Spacer()
                Text("Albums containing \(model?.title ?? "")")
                Spacer()
            }
            Table(albums, selection: $selection) {
                TableColumn("Title") { album in
                    Text(album.title)
                        .gesture(TapGesture(count: 2).onEnded {
                            selection = album.id
                            nextSearch = (album.title, .album)
                            model = nil
                        })
                        .simultaneousGesture(TapGesture().onEnded {
                                            self.selection = album.id
                                        })
                }
                TableColumn("Release Date") { album in
                    Text(formatter.dateString(of: album.releaseDate))
                }
            }
        }
        .padding()
    }
    
}

