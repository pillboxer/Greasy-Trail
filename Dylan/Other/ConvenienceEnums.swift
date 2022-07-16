//
//  ConvenienceEnums.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

enum DylanRecordType: CKRecord.RecordType {
    case album = "Album"
    case song = "Song"
    case performance = "Performance"
    
    var plural: String {
        rawValue + "s"
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
        
    case modificationDate
}

