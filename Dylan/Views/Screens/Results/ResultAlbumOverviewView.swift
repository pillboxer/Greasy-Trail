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
                OnTapButton(systemImage: "globe") {
                    NSWorkspace.shared.open(model!.officialURL())
                }
                .buttonStyle(.link)
                Spacer()
            }
            Spacer()
            List {
                ForEach(model?.songTitles ?? [], id: \.self) { title in
                    if title == "BREAK" {
                        Divider()
                    }
                    if let index = model?.songsIgnoringBreaks.firstIndex(of: title) {
                        ResultsInformationTitleAndDetailView(title: "\(String(index + 1)).", detail: title)
                            .onTapGesture {
                                nextSearch = Search(title: title, type: .song)
                                model = nil
                            }
                    }
                    
                }
            }
        }
        .padding()
    }
    
}
