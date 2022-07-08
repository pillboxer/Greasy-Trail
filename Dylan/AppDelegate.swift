//
//  AppDelegate.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Cocoa

class TestHelper: NSObject {
    
    static var isRunningTests: Bool {
       ProcessInfo.processInfo.environment["XCTestSessionIdentifier"] != nil
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let cloudKitManager = CloudKitManager(DylanDatabase)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if !TestHelper.isRunningTests {
            let _ = PersistenceController.shared
            Task {
                try await cloudKitManager.start()
            }
        }

    }
}
