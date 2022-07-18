//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

class NavigationViewModel: ObservableObject {
    
    enum NavigationSection: String, CaseIterable {
        case songs
        case albums
        case performances
        
        var recordType: DylanRecordType {
            switch self {
            case .songs:
                return .song
            case .albums:
                return .album
            case .performances:
                return .performance
            }
        }
    }
    
    @Published var selectedID: String? = NavigationSection.songs.rawValue
    
    var selectedSection: NavigationSection? {
        guard let id = selectedID else {
            return nil
        }
        return NavigationSection(rawValue: id)
    }
    
    var sidebarSections: [String] {
        NavigationSection.allCases.map { $0.rawValue }
    }
    
    
}

struct ContentView: View {
    
    @State private var songModel: SongDisplayModel?
    @State private var albumModel: AlbumDisplayModel?
    @State private var performanceModel: PerformanceDisplayModel?
    @State private var nextSearch: Search?

    @State private var addingType: NavigationViewModel.NavigationSection?
    
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    @ObservedObject var viewModel = NavigationViewModel()
    
    private let formatter = Formatter()
    
    var body: some View {
        Group {
            if let step = cloudKitManager.currentStep {
                if case let .failure(error) = step {
                   UploadFailureView(error: error)
                }
                else {
                    FetchProgressView(step: step)
                }
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
                NavigationView {
                    VStack {
                        List(viewModel.sidebarSections, id: \.self) { item in
                            HStack {
                                SidebarListRowView(selection: item, nextSearch: $nextSearch, addingType: $addingType)
                                    .environmentObject(viewModel)
                            }
                            .padding(4)
                        }
                        if let recordType = addingType?.recordType {
                            UploadView(recordType: recordType)
                        }
                        
                        SearchView(songModel: $songModel, albumModel: $albumModel, performanceModel: $performanceModel, nextSearch: $nextSearch)
                            .padding()
                    }
                }
            }
        }
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(formatter)
        .frame(width: 900, height: 600)
    }
}
