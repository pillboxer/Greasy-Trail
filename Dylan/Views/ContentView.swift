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

struct ContentView: View {
    
    let store: Store<AppState, AppAction>
    @ObservedObject private var viewStore: ViewStore<AppState>
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    @State private var selectedID: String?
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = store.view(id: "CONTENT")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                if let step = cloudKitManager.currentStep,
                   case let .failure(error) = step {
                    CloudKitFailureView(error: error)
                } else if viewStore.value.model != nil {
                    ResultView(store: store.scope(value: {
                        return SearchState(model: $0.model,
                                           failedSearch: $0.failedSearch,
                                           currentSearch: $0.currentSearch,
                                           ids: $0.selectedModel,
                                           isSearching: $0.isSearching)
                    }, action: {
                        .search($0)
                    }))
                } else {
                    HomeView(store: store,
                             fetchingType: cloudKitManager.fetchingType?.sidebarDisplayType,
                             progress: cloudKitManager.progress,
                             selectedID: $selectedID)
                }
            }
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .frame(minWidth: 900, minHeight: 600)
            HStack(alignment: .top) {
                Spacer()
                if viewStore.value.isSearching {
                ProgressView()
                    .scaleEffect(0.4)
                }
                    
            }
            .frame(maxHeight: 24)
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
