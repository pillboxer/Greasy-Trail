//
//  HomeView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 18/07/2022.
//

import SwiftUI
import GTCloudKit
import ComposableArchitecture
import Sidebar

struct HomeView: View {
    
    var store: Store<AppState, AppAction>
    @ObservedObject private var viewStore: ViewStore<AppState, Never>
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
        self.viewStore = ViewStore(store.actionless.scope(state: { $0 }))
        _selectedID = selectedID
    }
    
    var body: some View {
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
            }
            .padding(.vertical)
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
