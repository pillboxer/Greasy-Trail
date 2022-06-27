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
        HStack {
            TextField.init("Search", text: $text)
            Button {
                Task {
                  model = await detective.search(song: text)
                }
            } label: {
                Text("Go")
            }

        }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
