import ComposableArchitecture
import OSLog
import GTCloudKit
import Core
import AppKit

let logger = os.Logger(subsystem: .subsystem, category: "Command Menu")

struct CommandMenuState: Equatable {
    var mode: Mode?
}

enum CommandMenuAction: Equatable {
    case emailLogs(String?)
    case copyLogs
    case reset
}

enum CommandMenuError: Error, CustomStringConvertible {
    case couldNotFetchLogs
    case couldNotOpenEmail

    var description: String {
        switch self {
        case .couldNotFetchLogs:
            return tr("fetch_logs_error")
        case .couldNotOpenEmail:
            return tr("open_email_error")
        }
    }
    
}

let commandMenuReducer = Reducer<CommandMenuState, CommandMenuAction, Void> { state, action, _ in
    switch action {
    case .copyLogs:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
        state.mode = .fetchingLogs
        return .run { send in
            do {
                var string = ""
                let store = try OSLogStore(scope: .currentProcessIdentifier)
                let predicate = NSPredicate(format: "subsystem == '\(String.subsystem)'")
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
                await send(.emailLogs(string))
            } catch {
                logger.log(level: .error, "Error fetching logs: \(String(describing: error), privacy: .public)")
                await send(.emailLogs(nil))
            }
            logger.log("Successfully copied logs")
        }
    case .emailLogs(let string):
        guard let string = string else {
            state.mode = .operationFailed(GTError(CommandMenuError.couldNotFetchLogs))
            return .none
        }
        let service = NSSharingService(named: .composeEmail)
        guard let service = service else {
            state.mode = .operationFailed(GTError(CommandMenuError.couldNotOpenEmail))
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString(string, forType: .string)
            return .none
        }
        service.recipients = [tr("bug_report_to_address")]
        service.subject = tr("bug_report_subject")
        service.perform(withItems: [tr("bug_report_body"), string])
        return Effect(value: .reset)
    case .reset:
        state.mode = nil
        return .none
    }
}

private extension OSLogEntryLog.Level {
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
