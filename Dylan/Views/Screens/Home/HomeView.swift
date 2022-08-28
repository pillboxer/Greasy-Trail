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
    
    var store: Store<AppState, AppAction>
    @ObservedObject private var viewStore: ViewStore<AppState>
    let fetchingType: SidebarDisplayType?
    var progress: Double? = 0
    @Binding var selectedID: String?
    @State private var existingSelectedID: String?
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    
    init(store: Store<AppState, AppAction>,
         fetchingType: SidebarDisplayType?,
         progress: Double? = 0,
         selectedID: Binding<String?>) {
        self.store = store
        self.fetchingType = fetchingType
        self.progress = progress
        self.viewStore = store.view(id: "HOME")
        _selectedID = selectedID
    }
    
    var body: some View {
        print("Home View Body")
        return NavigationView {
            VStack {
                List(SidebarDisplayType.displayedTypes,
                     id: \.self,
                     children: \.children) { item in
                    HStack {
                        SidebarListRowView(store: store,
                                           displayType: item,
                                           isFetching: fetchingType == item,
                                           progress: progress,
                                           selectedID: $selectedID)
                    }
                    .padding(4)
                }
                SearchView(store: store.scope(value: {
                    SearchState(model: $0.model,
                                failedSearch: $0.failedSearch,
                                currentSearch: $0.currentSearch,
                                ids: $0.selectedModel,
                                isSearching: $0.isSearching)
                }, action: {
                    .search($0)
                }))
                .padding()
            }
            .padding()
        }
        .onChange(of: selectedID) { newValue in
            if newValue == SidebarDisplayType.performances.rawValue {
                selectedID = existingSelectedID
            }
            existingSelectedID = selectedID
        }
        .onAppear {
            selectedID = selectedID ?? SidebarDisplayType.songs.rawValue
        }
    }
}
