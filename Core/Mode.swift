public enum Mode: Equatable {
    case downloaded
    case downloading(progress: Double, DylanRecordType)
    case operationFailed(GTError)
    case uploading(progress: Double)
    case uploaded
    case fetchingLogs
    case couldNotFetchLogs
    case couldNotOpenEmail
    
    public var canStartNewOperation: Bool {
        switch self {
        case .downloading, .uploading:
            return false
        default:
            return true
        }
    }
}
