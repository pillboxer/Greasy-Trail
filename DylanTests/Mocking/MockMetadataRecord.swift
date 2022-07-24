//
//  MockMetadataRecord.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/07/2022.
//

import Foundation

@testable import Greasy_Trail
import CloudKit

class MockMetadataRecord {
    
    let name: String
    let file: Data
    let recordName = UUID().uuidString
    
    init(name: String, file: Data) {
        self.name = name
        self.file = file
    }
    
}

extension MockMetadataRecord: RecordType {
    
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }
    
    func string(for field: DylanRecordField) -> String? {
        switch field {
        case .name:
            return name
        default:
            return nil
        }
    }
    
    func data(for field: DylanRecordField) -> Data? {
        file
    }

}
