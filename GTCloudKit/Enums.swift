//
//  ConvenienceEnums.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit
import Core

public enum DylanRecordType: CKRecord.RecordType {
    case song = "Song"
    case album = "Album"
    case performance = "Performance"
    case appMetadata =  "AppMetadata"
    
    public static var displayedTypes: [DylanRecordType] {
        return [.song, .album, .performance]
    }

}

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
    
    // App Metadata
    case file
    case name

    case modificationDate
}

enum CloudKitManagerError: LocalizedError {
   
    case query(code: Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .query(let code):
            return String(formatted: "cloud_kit_query_error_\(code)")
        case .unknown:
            return String(formatted: "cloud_kit_upload_unknown")
        }
    }
   
}
