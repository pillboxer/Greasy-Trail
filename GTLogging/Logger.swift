//
//  Logger.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 24/07/2022.
//

import Foundation
import OSLog
import Cocoa

public class Logger {
    
    public static func copyLogs() {
        // FIXME: This should not block
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
        var string = ""
        do {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            let predicate = NSPredicate(format: "subsystem == '\(subsystem)'")
            let entries = try store.getEntries(with: [], at: nil, matching: predicate)
            for entry in entries {
                if let entry = entry as? OSLogEntryLog {
                    let dateString = dateFormatter.string(from: entry.date)
                    let levelString = entry.level.levelString
                    let composedMessage = entry.composedMessage
                    let subsystemAndCategory = "[\(entry.category)]"
                    string += "\(dateString) \(levelString) - \(subsystemAndCategory) \(composedMessage)\n"
                }
            }
        } catch {
            os_log("Error fetching logs %{public}@", log: Log_OSLog, type: .error, String(describing: error))
            return
        }
        os_log("Successfully copied logs", log: Log_OSLog)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(string, forType: .string)
    }
}

extension OSLogEntryLog.Level {
    var levelString: String {
        switch self {
        case .undefined:
            return "Undefined"
        case .debug:
            return "Debug"
        case .info:
            return "Info"
        case .notice:
            return "Notice"
        case .error:
            return "Error"
        case .fault:
            return "Fault"
        @unknown default:
            return "Unknown default"
        }
    }
}
