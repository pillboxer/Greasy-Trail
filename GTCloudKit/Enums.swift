import CloudKit
import Core

public enum DylanReferenceType: CKRecord.RecordType {
    case albums = "albums"
    case songs = "songs"
}

public enum DylanRecordField: String {
    // Song
    case title
    case author

    // Album
    case releaseDate
    case metadata

    // Performance
    case venue
    case date
    case lbNumbers = "LBNumbers"
    case dateFormat
    case baseSongUUID
    
    // App Metadata
    case file
    case name
    
    // Purchase
    case amount
    case type

    case songs
}

enum CloudKitManagerError: Error {
   
    case query(code: Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .query(let code):
            return tr("cloud_kit_query_error_\(code)")
        case .unknown:
            return tr("cloud_kit_upload_unknown")
        }
    }
   
}
