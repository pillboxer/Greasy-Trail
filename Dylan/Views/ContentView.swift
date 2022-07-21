//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

struct ContentView: View {

    @State private var songModel: SongDisplayModel?
    @State private var albumModel: AlbumDisplayModel?
    @State private var performanceModel: PerformanceDisplayModel?
    @State private var nextSearch: Search?
    @State private var recordTypeToAdd: DylanRecordType?
    @State private var selectedID: String?
    @EnvironmentObject private var cloudKitManager: CloudKitManager

    private let formatter = Formatter()

    var body: some View {
        Group {
            if let step = cloudKitManager.currentStep,
               case let .failure(error) = step {
                   UploadFailureView(error: error)
            } else if songModel != nil {
                ResultView(songModel: $songModel,
                           nextSearch: $nextSearch,
                           currentViewType: .songOverview)
            } else if albumModel != nil {
                ResultView(albumModel: $albumModel,
                           nextSearch: $nextSearch,
                           currentViewType: .albumOverview)
            } else if performanceModel != nil {
                ResultView(performanceModel: $performanceModel,
                           nextSearch: $nextSearch,
                           currentViewType: .performanceOverview)
            } else {
                HomeView(fetchingType: cloudKitManager.fetchingType,
                         progress: cloudKitManager.progress,
                         songModel: $songModel,
                         albumModel: $albumModel,
                         performanceModel: $performanceModel,
                         recordTypeToAdd: $recordTypeToAdd,
                         nextSearch: $nextSearch,
                         selectedID: $selectedID)
            }
        }
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(formatter)
        .frame(width: 900, height: 600)
    }
}
