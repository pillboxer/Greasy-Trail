//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI
import ComposableArchitecture
import GTCoreData
import Result
import Search
import GTCloudKit
import Sidebar
import BottomBar
import Add

struct ContentView: View {
    
    let store: Store<AppState, AppAction>
    @ObservedObject private var viewStore: ViewStore<AppState, Never>
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    @State private var selectedID: String?
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = ViewStore(store.actionless.scope(state: { $0 }))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch viewStore.selectedSection {
                case .add:
                    AddView(store: store.scope(state: { $0.addState }, action: { .add($0) }))
                case .home:
                    if let step = cloudKitManager.currentStep,
                       case let .failure(error) = step {
                        CloudKitFailureView(error: error)
                    } else if viewStore.model != nil {
                        ResultView(store: store.scope(state: { $0.searchState }, action: { .search($0) }))
                    } else {
                        HomeView(store: store,
                                 fetchingType: cloudKitManager.fetchingType?.sidebarDisplayType,
                                 progress: cloudKitManager.progress,
                                 selectedID: $selectedID)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .frame(minWidth: 900, minHeight: 600)
            BottomBarView(store: store.scope(state: { $0.bottomBarState },
                                             action: { .bottomBar($0) }))
        }
    }
}

private extension DylanRecordType {
    var sidebarDisplayType: SidebarDisplayType? {
        switch self {
        case .song:
            return .songs
        case .album:
            return .albums
        case .performance:
            return .performances
        case .appMetadata:
            return nil
        }
    }
}
