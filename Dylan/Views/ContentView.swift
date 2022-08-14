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

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    @State private var selectedID: String?
    
    var body: some View {
        Group {
            if let step = cloudKitManager.currentStep,
               case let .failure(error) = step {
                CloudKitFailureView(error: error)
            } else if store.value.model != nil {
                ResultView(store: store.view(value: {
                    return SearchState(model: $0.model, failedSearch: $0.failedSearch, currentSearch: $0.currentSearch)
                }, action: {
                    .search($0)
                }))
            } else {
                HomeView(fetchingType: cloudKitManager.fetchingType,
                         progress: cloudKitManager.progress,
                         selectedID: $selectedID)
                .environmentObject(store)
            }
        }
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .frame(width: 900, height: 600)
    }
}
