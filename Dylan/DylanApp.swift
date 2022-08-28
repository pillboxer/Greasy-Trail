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
import Add
import Search

@main
struct DylanApp: App {
 
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let appStore = Store(initialValue: AppState(),
                         reducer: appReducer,
                         environment: AppEnvironment(search: Searcher().search,
                                                     randomSong: Searcher().randomSong,
                                                     randomAlbum: Searcher().randomAlbum,
                                                     randomPerformance: Searcher().randomPerformance))
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: appStore)
                .environmentObject(appDelegate.cloudKitManager)
        }
        WindowGroup {
            AddView(store: appStore.scope(value: { state in
                AddState(selectedRecordToAdd: state.selectedRecordToAdd)
            }, action: { action in
                return .add(action)
            }))
        }
        .handlesExternalEvents(matching: Set(Array(["Add"])))
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Add...") {
                    OpenWindows.Add.open()
                }.keyboardShortcut("N", modifiers: .command)
            }
            CommandMenu("developer_menu_title") {
                Button("developer_menu_button_0") {
                    PersistenceController.shared.reset()
                    CloudKitManager.resetAllFetchDates()
                    Task {
                        await appDelegate.cloudKitManager.start()
                    }
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
    case Add
    
    func open() {
        if let url = URL(string: "dylan://\(self.rawValue)") {
            NSWorkspace.shared.open(url)
        }
    }
}
