//
//  HomeView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 18/07/2022.
//

import SwiftUI
import Search
import GTCloudKit
import ComposableArchitecture
import Sidebar

struct HomeView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    let fetchingType: SidebarDisplayType?
    var progress: Double? = 0
    @Binding var selectedID: String?
    @State private var existingSelectedID: String?
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    
    var body: some View {
        NavigationView {
            VStack {
                List(SidebarDisplayType.displayedTypes,
                     id: \.self,
                     children: \.children) { item in
                    HStack {
                        SidebarListRowView(displayType: item,
                                           isFetching: fetchingType == item,
                                           progress: progress,
                                           selectedID: $selectedID)
                    }
                    .padding(4)
                }
                SearchView(store: store.view(value: {
                    SearchState(model: $0.model, failedSearch: $0.failedSearch, currentSearch: $0.currentSearch)
                }, action: {
                    .search($0)
                }))
                .padding()
            }
        }
        .onChange(of: selectedID) { newValue in
            if newValue == SidebarDisplayType.performances.rawValue {
                selectedID = existingSelectedID
            }
            existingSelectedID = selectedID
        }
        .onAppear {
            selectedID = SidebarDisplayType.songs.rawValue
        }
    }
}
