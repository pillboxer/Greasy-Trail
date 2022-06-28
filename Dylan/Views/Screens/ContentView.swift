//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var songModel: SongDisplayModel?
    
    var body: some View {
        if let songModel = songModel {
            ResultView(model: songModel)
        }
        else {
            SearchView(model: $songModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchView: View {
    
    @State private var text: String = ""
    @Binding var model: SongDisplayModel?
    
    @StateObject private var detective = Detective()
    
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Spacer()
                NSTextFieldRepresentable(placeholder: "search_placeholder", text: $text)
                    .padding(.horizontal)
                    .frame(width: 600 / 4)
                Spacer()
            }
            Button {
                let savedText = text
                text = ""
                Task {
                    model = await detective.search(song: savedText)
                }
            } label: {
                Text("Go")
            }
        }
        .padding(.bottom, 16)
        .frame(width: 600, height: 400)
    }
    
}

struct ResultView: View {
    
    let model: SongDisplayModel
    
    var body: some View {
        VStack {
            
            Text("Song: \(model.song.title)")
            Spacer()
            
            if let albums = model.albums {
                ForEach(albums) { album in
                    Text(album.title)
                }
            }
            
            else {
                Text("Never released on an album")
            }
            
            
        }
    }
    
}
