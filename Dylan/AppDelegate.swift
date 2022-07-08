//
//  AppDelegate.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let cloudKitManager = CloudKitManager(DylanDatabase)
    
    lazy var detective: Detective = {
        Detective(cloudKitManager)
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let _ = PersistenceController.shared
        Task {
            try await cloudKitManager.start()
        }
    }
}
