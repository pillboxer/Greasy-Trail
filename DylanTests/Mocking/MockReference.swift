//
//  MockReference.swift
//  DylanTests
//
//  Created by Henry Cooper on 26/06/2022.
//

import CloudKit
@testable import Dylan

class MockAlbumReference: ReferenceType {
    
    let recordName = UUID().uuidString
    let title: String
    init(title: String) {
        self.title = title
    }
    
    var record: MockAlbumRecord { MockAlbumRecord(title: title) }
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }
}

class MockAlbumRecord: RecordType, CustomStringConvertible {
    
    // For the moment returning no songs
    func references(of referenceType: Dylan.DylanReferenceType) -> [Dylan.ReferenceType] {
        []
    }
    
    func string(for field: DylanRecordField) -> String {
        switch field {
        case .title:
            return title
        }
    }
    
    
    let title: String
    let recordName = UUID().uuidString

    init(title: String) {
        self.title = title
    }
    
    
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }

    var description: String {
        """
        album title: \(title)
        """
    }
    
    
}
