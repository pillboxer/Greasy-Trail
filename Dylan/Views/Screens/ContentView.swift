//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    private let formatter = Formatter()

    @State var songModel: SongDisplayModel?
    var body: some View {
        Group {
            if let songModel = songModel {
                ResultView(model: songModel)
                    .environmentObject(formatter)
            }
            else {
                SearchView(model: $songModel)
            }
        }
        .frame(width: 600, height: 400)

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
            HStack{
                Spacer()
                NSTextFieldRepresentable(placeholder: "search_placeholder", text: $text)
                    .frame(maxWidth: 250)
                Spacer()
            }
            HStack(spacing: 16) {
                Button {
                    let savedText = text
                    text = ""
                    Task {
                        model = await detective.search(song: savedText.capitalized)
                    }
                } label: {
                    Text("Song")
                }
                Button {
                    let savedText = text
                    text = ""
                    Task {
                        model = await detective.search(song: savedText.capitalized)
                    }
                } label: {
                    Text("Album")
                }
            }
        }
        .padding(.bottom, 16)
    }
    
}

struct ResultView: View {
    
    
    enum ResultViewType {
        case overview
        case albums([Album])
    }
    
    let model: SongDisplayModel
    @State private var currentViewType: ResultViewType = .overview
    
    var body: some View {
        
        switch currentViewType {
        case .overview:
            ResultOverview(model: model, currentViewType: $currentViewType)
        case .albums(let albums):
            ResultAlbumsTableView(albums: albums)
        }
    }
    
}

struct ResultOverview: View {
    
    let model: SongDisplayModel
    @Binding var currentViewType: ResultView.ResultViewType
    @EnvironmentObject var formatter: Formatter
    
    var body: some View {
        VStack(spacing: 16) {
            Text(model.song.title)
                .font(.headline)
            Spacer()
            if let first = model.firstAlbumAppearance {
                ResultsInformationTitleAndDetailView(title: "results_information_title_first_appearance", detail: first.title)
                ResultsInformationTitleAndDetailView(title: "results_information_title_song_author", detail: model.author)
                if let performance = model.firstLivePerformance {
                    ResultsInformationTitleAndDetailView(title: "results_information_title_first_live_performance", detail: formatter.formatted(performance: performance))
                }
            }
            else {
                Text("Never released on an album")
            }
            Spacer()
            Spacer()
            if let albums = model.albums {
                HStack {
                    Button {
                        currentViewType = .albums(albums)
                    } label: {
                        Text("Albums")
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
    
}

struct ResultsInformationTitleAndDetailView: View {
    
    let title: String
    let detail: String
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
            Spacer()
            Text(detail)
        }
    }
    
}

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
