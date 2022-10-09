import ComposableArchitecture
import OSLog
import GTCloudKit
import Core
import AppKit
import GTCoreData

let logger = os.Logger(subsystem: .subsystem, category: "Command Menu")

struct CommandMenuState: Equatable {
    var mode: Mode?
    var alert: AlertState<CommandMenuAction>?
}

enum CommandMenuAction: Equatable {
    case emailLogs(String?)
    case copyLogs
    case toggleDeleteAlert
    case deleteConfirmed
    case finishDelete
    case quit
    case throwDeleteError(GTError)
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
    case .throwDeleteError(let error):
        state.mode = .operationFailed(error)
        return .none
    case .deleteConfirmed:
        return .run(operation: { send in
            try await PersistenceController.shared.reset()
            await send(.finishDelete)
        }, catch: { error, send in
            await send(.throwDeleteError(.init(error)))
        })
    case .finishDelete:
        state.alert = AlertState(
            title: .init("delete_confirmation"), buttons: [.default(.init("generic_ok"), action: .send(.quit))])
        return .none
    case .quit:
        NSApp.terminate(nil)
        return .none
    case .toggleDeleteAlert:
        if state.alert == nil {
            if state.mode?.canStartNewOperation ?? true {
                state.alert = AlertState(
                    title: TextState("delete_alert_message"),
                    primaryButton: .destructive(
                        .init("generic_delete"), action: .send(.deleteConfirmed)),
                    secondaryButton: .cancel(.init("generic_cancel")))
            } else {
                state.alert = AlertState(
                    title: .init("delete_not_allowed"), buttons: [.default(.init("generic_ok"))])
                return .none
            }
        } else {
            state.alert = nil
        }
        return .none
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
