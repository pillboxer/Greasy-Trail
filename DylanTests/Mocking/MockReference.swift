//
//  MockReference.swift
//  DylanTests
//
//  Created by Henry Cooper on 26/06/2022.
//

import CloudKit
@testable import Dylan

struct MockAlbumReference: ReferenceType {
    
    let recordName = UUID().uuidString
    let title: String
    let releaseDate: Double
    
    init(title: String, releaseDate: Double) {
        self.title = title
        self.releaseDate = releaseDate
    }
    
    var record: MockAlbumRecord { MockAlbumRecord(title: title, releaseDate: releaseDate) }
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }
}

struct MockAlbumRecord: RecordType, CustomStringConvertible {
    
    let title: String
    let releaseDate: Double
    let recordName = UUID().uuidString
    
    init(title: String, releaseDate: Double) {
        self.title = title
        self.releaseDate = releaseDate
    }
    
    func string(for field: DylanRecordField) -> String? {
        switch field {
        case .title:
            return title
        default:
            return nil
        }
    }
    
    func double(for field: DylanRecordField) -> Double? {
        switch field {
        case .releaseDate:
            return releaseDate
        default:
            return nil
        }
    }
    
    // For the moment returning no songs
    func references(of referenceType: Dylan.DylanReferenceType) -> [Dylan.ReferenceType] {
        []
    }
        
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }

    var description: String {
        """
        album title: \(title)
        """
    }
    
    
}
