//
//  MockSongRecord.swift
//  DylanTests
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation
@testable import Dylan
import CloudKit

class MockSongRecord {
    
    private let recordName = UUID().uuidString
    let title: String
    
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }

    init(title: String) {
        self.title = title
    }
}

extension MockSongRecord: CustomStringConvertible {
    
    var description: String {
        """
            song title: \(title)
        """
    }
    
}

extension MockSongRecord: RecordType {
    
    func references(of referenceType: Dylan.DylanReferenceType) -> [Dylan.ReferenceType] {
        []
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
        nil
    }
    
}

extension MockSongRecord: MockRecordType {
    
    func asReferenceType() -> MockReferenceType {
        MockReferenceType(title: title, recordID: recordID)
    }
    
}
