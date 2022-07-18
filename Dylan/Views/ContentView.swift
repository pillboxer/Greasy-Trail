//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

//class NavigationViewModel: ObservableObject {
//
//    enum NavigationSection: String, CaseIterable {
//        case songs
//        case albums
//        case performances
//
//        var recordType: DylanRecordType {
//            switch self {
//            case .songs:
//                return .song
//            case .albums:
//                return .album
//            case .performances:
//                return .performance
//            }
//        }
//    }
//
//    @Published var selectedID: String? = DylanRecordType.song.rawValue
//
//    var selectedSection: NavigationSection? {
//        guard let id = selectedID else {
//            return nil
//        }
//        return NavigationSection(rawValue: id)
//    }
//
//    var sidebarSections: [String] {
//        NavigationSection.allCases.map { $0.rawValue }
//    }
//
//
//}

struct ContentView: View {
    
    @State private var songModel: SongDisplayModel?
    @State private var albumModel: AlbumDisplayModel?
    @State private var performanceModel: PerformanceDisplayModel?
    @State private var nextSearch: Search?
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    
    private let formatter = Formatter()
    
    var body: some View {
        Group {
            if let step = cloudKitManager.currentStep,
               case let .failure(error) = step {
                   UploadFailureView(error: error)
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
            else {
                HomeView(fetchingType: cloudKitManager.fetchingType, progress: cloudKitManager.progress, songModel: $songModel, albumModel: $albumModel, performanceModel: $performanceModel, nextSearch: $nextSearch)
            }
        }
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(formatter)
        .frame(width: 900, height: 600)
    }
}
