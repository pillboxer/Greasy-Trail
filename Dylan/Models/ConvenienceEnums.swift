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
}

enum DylanRecordField: String {
    case title
}

