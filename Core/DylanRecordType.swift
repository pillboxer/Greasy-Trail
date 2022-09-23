import CloudKit

public enum DylanRecordType: CKRecord.RecordType, CaseIterable {
    case song = "Song"
    case album = "Album"
    case performance = "Performance"
    case appMetadata =  "AppMetadata"
    
    public static var displayedTypes: [DylanRecordType] {
        return [.song, .album, .performance]
    }

}
