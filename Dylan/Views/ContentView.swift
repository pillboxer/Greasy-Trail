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
    @ObservedObject var store: Store<AppState, AppAction>
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    @State private var selectedID: String?
    
    var body: some View {
        print("ContentView.body")
        return Group {
            if let step = cloudKitManager.currentStep,
               case let .failure(error) = step {
                CloudKitFailureView(error: error)
            } else if store.value.model != nil {
                ResultView(store: store.scope(value: {
                    return SearchState(model: $0.model, failedSearch: $0.failedSearch, currentSearch: $0.currentSearch)
                }, action: {
                    .search($0)
                }))
            } else {
                HomeView(fetchingType: cloudKitManager.fetchingType?.sidebarDisplayType,
                         progress: cloudKitManager.progress,
                         selectedID: $selectedID)
                .environmentObject(store)
            }
        }
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .frame(minWidth: 900, minHeight: 600)
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
