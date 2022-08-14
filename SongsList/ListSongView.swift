//
//  ListSongView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 14/08/2022.
//

import SwiftUI
import UI

struct ListSongView: View {
    
    let index: Int
    let title: String
    let author: String
    let onTap: () -> Void
    let onButtonTap: (ListRowButton) -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(index + 1).")
            ListRowView(headline: title, subheadline: author, buttons: [.speaker, .globe], onTap: {
                onTap()
            }, buttonTap: onButtonTap)
        }
    }
}
