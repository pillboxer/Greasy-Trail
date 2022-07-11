//
//  RecentPerformancesView.swift
//  Dylan
//
//  Created by Henry Cooper on 11/07/2022.
//

import SwiftUI
struct RecentsView: View {
    
    @Binding var nextSearch: Search?

    @State private var selection: HomeView.RecentViewType
    
    @FetchRequest private var performances: FetchedResults<Performance>
    @FetchRequest private var albums: FetchedResults<Album>
    @Environment(\.managedObjectContext) var managedObjectContext

    
    init(nextSearch: Binding<Search?>) {
        let limit = 10
        let pRequest: NSFetchRequest<Performance> = Performance.fetchRequest()
        pRequest.fetchLimit = limit
        pRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let aRequest: NSFetchRequest<Album> = Album.fetchRequest()
        aRequest.fetchLimit = limit
        aRequest.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        _albums = FetchRequest(fetchRequest: aRequest)
        _performances = FetchRequest(fetchRequest: pRequest)
        _nextSearch = nextSearch
        let int = UserDefaults.standard.integer(forKey: "last_selected_recents_view")
        _selection = State(initialValue: HomeView.RecentViewType(rawValue: int) ?? .albums)
    }
    
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                ForEach(HomeView.RecentViewType.allCases, id: \.self) {
                    Text(LocalizedStringKey($0.pickerValue))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
           
            if selection == .performances {
                List(performances) { performance in
                    RecentPerformanceRow(venue: performance.venue!, date: performance.date, nextSearch: $nextSearch)
                }
            }
            else if selection == .albums {
                List(albums) { album in
                    RecentAlbumRow(title: album.title!, date: album.releaseDate, nextSearch: $nextSearch)
                }
            }
        }
        .onChange(of: selection) { newValue in
            print("Setting to \(newValue)")
            UserDefaults.standard.set(newValue.rawValue, forKey: "last_selected_recents_view")
        }

    }
    
}
