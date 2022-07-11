//
//  Globals.swift
//  Dylan
//
//  Created by Henry Cooper on 26/06/2022.
//

import Foundation
import CloudKit
import OSLog

let DylanContainer = CKContainer(identifier: "iCloud.Dylan")
let DylanDatabase = DylanContainer.publicCloudDatabase

// Logging
let subsystem = "com.Dylan"
let Log_CloudKit = OSLog(subsystem: subsystem, category: "CloudKit Fetch")
let Log_AppDelegate = OSLog(subsystem: subsystem, category: "App Delegate")
let Log_Detective = OSLog(subsystem: subsystem, category: "Detective")
