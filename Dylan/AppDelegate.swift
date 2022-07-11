//
//  AppDelegate.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Cocoa
import OSLog

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let cloudKitManager = CloudKitManager(DylanDatabase)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let isRunningTests = TestHelper.isRunningTests
        os_log("Test suite is being run: %{BOOL}d", log: Log_AppDelegate, isRunningTests)
        if !isRunningTests {
            let _ = PersistenceController.shared
            Task {
                try await cloudKitManager.start()
            }
        }

    }
}
