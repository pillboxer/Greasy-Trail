//
//  HomeView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 18/07/2022.
//

import SwiftUI

enum SidebarSection: String, CaseIterable {
    case songs = "Song"
    case album = "Album"
    case performances = "Performance"
}

struct HomeView: View {
    
    let fetchingType: DylanRecordType?
    var progress: Double? = 0
    @Binding var songModel: SongDisplayModel?
    @Binding var albumModel: AlbumDisplayModel?
    @Binding var performanceModel: PerformanceDisplayModel?
    @State private var recordTypeToAdd: DylanRecordType?
    @Binding var nextSearch: Search?
    @State private var selectedID: String?
    
    var body: some View {
        NavigationView {
            VStack {
                List(DylanRecordType.allCases, id: \.self) { item in
      
                    HStack {
                        SidebarListRowView(recordType: item, isFetching: fetchingType == item, progress: progress, selection: item.rawValue, nextSearch: $nextSearch, selectedID: $selectedID) {
                            recordTypeToAdd = item
                        }
                    }
                    .padding(4)
                }
                if let recordType = recordTypeToAdd {
                    UploadView(recordType: recordType)
                }

                SearchView(songModel: $songModel, albumModel: $albumModel, performanceModel: $performanceModel, nextSearch: $nextSearch)
                    .padding()
            }
        }
    }
}
