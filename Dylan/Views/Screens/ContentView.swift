//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

#warning("MOVE ME")
struct Search: Equatable {
    let title: String
    let type: DylanSearchType
}

struct ContentView: View {
    
    private let formatter = Formatter()

    @EnvironmentObject private var cloudKitManager: CloudKitManager
    
    @State private var songModel: SongDisplayModel?
    @State private var albumModel: AlbumDisplayModel?
    @State private var performanceModel: PerformanceDisplayModel?
    @State private var nextSearch: Search?
    
    var body: some View {
        Group {
            if let step = cloudKitManager.currentStep {
                FetchProgressView(step: step)
            }
            else if let _ = songModel {
                ResultView(songModel: $songModel, nextSearch: $nextSearch, currentViewType: .songOverview)
            }
            else if let _ = albumModel {
                ResultView(albumModel: $albumModel, nextSearch: $nextSearch, currentViewType: .albumOverview)
            }
            else if let _ = performanceModel {
                ResultView(performanceModel: $performanceModel, nextSearch: $nextSearch, currentViewType: .performanceOverview)
            }
            else if let _ = nextSearch {
                SearchView(songModel: $songModel, albumModel: $albumModel, performanceModel: $performanceModel, nextSearch: $nextSearch)
            }
            else {
                SearchView(songModel: $songModel, albumModel: $albumModel, performanceModel: $performanceModel, nextSearch: $nextSearch)
            }
        }
        .environmentObject(formatter)
        .environmentObject(cloudKitManager)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .frame(minWidth: 600, minHeight: 400)

    }
}
