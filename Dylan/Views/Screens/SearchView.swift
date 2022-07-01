//
//  SearchView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

struct SearchView: View {
    
    @State private var text: String = ""
    @Binding var model: SongDisplayModel?
    @StateObject private var detective = Detective()
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                NSTextFieldRepresentable(placeholder: "search_placeholder", text: $text)
                    .frame(maxWidth: 250)
                Spacer()
            }
            HStack(spacing: 16) {
                OnTapButton(text: "Song") {
                    let savedText = text
                    text = ""
                    Task {
                        model = await detective.search(song: savedText)
                    }
                }
            }
        }
        .padding(.bottom, 16)
    }
    
}
