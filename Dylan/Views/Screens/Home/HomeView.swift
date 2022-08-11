//
//  HomeView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 18/07/2022.
//

import SwiftUI
import ComposableArchitecture
import Search

enum SidebarSection: String, CaseIterable {
    case songs = "Song"
    case album = "Album"
    case performances = "Performance"
}

struct HomeView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    let fetchingType: DylanRecordType?
    var progress: Double? = 0
    @State var recordTypeToAdd: DylanRecordType?
    @Binding var selectedID: String?
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    
    var body: some View {
        NavigationView {
            VStack {
                List(DylanRecordType.displayedTypes, id: \.self) { item in
                    HStack {
                        SidebarListRowView(recordType: item,
                                           isFetching: fetchingType == item,
                                           progress: progress,
                                           selectedID: $selectedID) {
                            recordTypeToAdd = item
                        }
                    }
                    .padding(4)
                }
                if let recordType = recordTypeToAdd {
                    // FIXME: UPloade view model
                    UploadView(recordType: recordType) { model in
                        Task {
                            await cloudKitManager.upload(model)
                        }
                    }
                }
                SearchView(store: store.view(value: {
                    SearchState(model: $0.model, failedSearch: $0.failedSearch, currentSearch: $0.currentSearch)
                }, action: {
                    .search($0)
                }))
                .padding()
            }
        }
    }
}
