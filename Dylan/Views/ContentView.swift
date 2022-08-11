//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI
import ComposableArchitecture
import GTCoreData

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
                ResultView()
                    .environmentObject(store)
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
