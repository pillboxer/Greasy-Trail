//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedID: String?
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    @EnvironmentObject private var searchViewModel: SearchViewModel

    var body: some View {
        Group {
            if let step = cloudKitManager.currentStep,
               case let .failure(error) = step {
                   CloudKitFailureView(error: error)
            } else if searchViewModel.hasResult {
                ResultView()
            } else {
                HomeView(fetchingType: cloudKitManager.fetchingType,
                         progress: cloudKitManager.progress,
                         selectedID: $selectedID)
            }
        }
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(searchViewModel)
        .frame(width: 900, height: 600)
    }
}
