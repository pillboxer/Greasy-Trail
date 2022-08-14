//
//  DylanApp.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI
import GTLogging
import ComposableArchitecture
import GTCoreData
import GTCloudKit

@main
struct DylanApp: App {
 
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialValue: AppState(), reducing: appReducer))
                .environmentObject(appDelegate.cloudKitManager)
                .environmentObject(SearchViewModel())
        }
        WindowGroup {
            SpellingResolverView(manager: SpellingResolverManager(cloudKitManager: appDelegate.cloudKitManager))
        }
        .handlesExternalEvents(matching: Set(Array(["SpellingResolverView"])))
        
        .commands {
            CommandMenu("developer_menu_title") {
                Button("developer_menu_button_0") {
                    PersistenceController.shared.reset()
                    CloudKitManager.resetAllFetchDates()
                    Task {
                        await appDelegate.cloudKitManager.start()
                    }
                }
                Button("developer_menu_button_1") {
                    OpenWindows.SpellingResolver.open()
                }
                Button("developer_menu_button_2") {
                    Logger.copyLogs()
                }
            }
        }

    }
}

// swiftlint: disable identifier_name
enum OpenWindows: String, CaseIterable {
    case SpellingResolver = "SpellingResolverView"

    func open() {
        if let url = URL(string: "dylan://\(self.rawValue)") {
            NSWorkspace.shared.open(url)
        }
    }
}
