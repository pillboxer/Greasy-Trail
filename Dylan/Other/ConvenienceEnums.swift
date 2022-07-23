//
//  ConvenienceEnums.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

enum DylanRecordType: CKRecord.RecordType {
    case song = "Song"
    case album = "Album"
    case performance = "Performance"
    case appMetadata =  "AppMetadata"
    
    static var displayedTypes: [DylanRecordType] {
        return [.song, .album, .performance]
    }

}

enum DylanReferenceType: CKRecord.RecordType {
    case albums = "albums"
    case songs = "songs"
}

enum DylanRecordField: String {
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
