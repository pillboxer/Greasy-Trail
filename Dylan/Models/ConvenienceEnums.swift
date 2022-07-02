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
}

enum DylanReferenceType: CKRecord.RecordType {
    case albums = "albums"
    case firstLivePerformance = "firstLivePerformance"
}

enum DylanRecordField: String {
    // Song
    case title
    case firstLivePerformance

    // Album
    case releaseDate

    // Performance
    case venue
    case date
    
}

