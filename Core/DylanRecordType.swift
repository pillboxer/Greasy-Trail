import CloudKit

public enum DylanRecordType: CKRecord.RecordType, CaseIterable {
    case song = "Song"
    case album = "Album"
    case performance = "Performance"
    case appMetadata =  "AppMetadata"
    case adminMetadata = "AdminMetadata"
}
