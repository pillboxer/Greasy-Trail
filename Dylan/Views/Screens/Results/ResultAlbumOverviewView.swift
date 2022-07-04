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
                Text(model?.album.title ?? "")
                    .font(.headline)
                Spacer()
            }
 
            Spacer()
            List {
                
                ForEach(model?.songTitles ?? [], id: \.self) { title in
                    if let index = model?.songTitles.firstIndex(of: title) {
                        ResultsInformationTitleAndDetailView(title: "\(String(index + 1)).", detail: title)
                            .onTapGesture {
                                nextSearch = (title, .song)
                                model = nil
                            }
                    }
                }
            }

        }
        .padding()
    }
    
}
