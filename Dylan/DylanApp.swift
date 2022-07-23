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
        WindowGroup {
            SpellingResolverView(manager: SpellingResolverManager(cloudKitManager: appDelegate.cloudKitManager))
                
        }.handlesExternalEvents(matching: Set(arrayLiteral: "SpellingResolverView"))
        
        .commands {
            CommandMenu("Developer") {
                Button("Delete and Reset") {
                    PersistenceController.shared.reset()
                    CloudKitManager.resetAllFetchDates()
                    Task {
                        try await appDelegate.cloudKitManager.start()
                    }
                }
                Button("Add Alternate Spelling") {
                    OpenWindows.SpellingResolver.open()
                }

            }
        }

    }
}

// swiftlint: disable identifier_name
enum OpenWindows: String, CaseIterable {
    case SpellingResolver = "SpellingResolverView"

    func open() {
        if let url = URL(string: "dylan://\(self.rawValue)") { //replace myapp with your app's name
            NSWorkspace.shared.open(url)
        }
    }
}
