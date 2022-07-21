//
//  DylanApp.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

@main
struct DylanApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.cloudKitManager)
        }
        .commands {
            CommandMenu("Data") {
                Button("Delete and Reset") {
                    PersistenceController.shared.reset()
                    Task {
                        try await appDelegate.cloudKitManager.start(true)
                    }
                }

            }
        }

    }
}
