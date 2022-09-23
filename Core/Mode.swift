public enum Mode: Equatable {
    case downloaded
    case downloading(progress: Double, DylanRecordType)
    case operationFailed(GTError)
    case uploading(progress: Double)
    case uploaded
    case fetchingLogs
    case couldNotFetchLogs
    case couldNotOpenEmail
}
