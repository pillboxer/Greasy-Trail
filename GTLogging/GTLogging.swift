//
//  GTLogging.swift
//  GTLogging
//
//  Created by Henry Cooper on 07/08/2022.
//

// swiftlint:disable identifier_name
import Foundation

import OSLog

public let subsystem = "com.Dylan"
public let Log_CloudKit = OSLog(subsystem: subsystem, category: "CloudKit Fetch")
public let Log_AppDelegate = OSLog(subsystem: subsystem, category: "App Delegate")
public let Log_Detective = OSLog(subsystem: subsystem, category: "Detective")
public let Log_CoreData = OSLog(subsystem: subsystem, category: "Core Data")
public let Log_SpellingResolver = OSLog(subsystem: subsystem, category: "Spelling Resolver")
public let Log_OSLog = OSLog(subsystem: subsystem, category: "OSLog")
