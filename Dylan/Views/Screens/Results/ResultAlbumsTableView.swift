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
    @EnvironmentObject var formatter: Formatter
    
    var body: some View {
        Table(albums) {
            TableColumn("Title", value: \.title)
            TableColumn("Release Date") { album in
                Text(formatter.dateString(of: album.releaseDate))
            }
        }
    }
    
}

