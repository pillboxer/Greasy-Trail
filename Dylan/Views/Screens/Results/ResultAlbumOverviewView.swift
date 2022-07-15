//
//  ResultAlbumOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 02/07/2022.
//

import SwiftUI

struct ResultAlbumOverviewView: View{
    
    @Binding var model: AlbumDisplayModel?
    @Binding var nextSearch: Search?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "house")
                    .onTapGesture {
                        model = nil
                    }
                Spacer()
                Text(model?.title ?? "")
                    .font(.headline)
                Spacer()
            }
            Spacer()
            HStack {
                SongsListView(songs: model?.songs ?? []) { title in
                    nextSearch = Search(title: title, type: .song)
                    model = nil
                }
            }
        }
        .padding()
    }
    
}
