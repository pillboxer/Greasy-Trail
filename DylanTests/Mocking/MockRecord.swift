//
//  MockRecord.swift
//  DylanTests
//
//  Created by Henry Cooper on 26/06/2022.
//

@testable import Dylan
import CloudKit

class MockSongRecord: RecordType, CustomStringConvertible {
    
    let recordName = UUID().uuidString
    let references: [MockAlbumReference]
    
    let title: String
    
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }

    init(title: String, references: [MockAlbumReference]) {
        self.title = title
        self.references = references
    }
    
    func references(of referenceType: Dylan.DylanReferenceType) -> [Dylan.ReferenceType] {
        references
    }
 
    var description: String {
        """
            song title: \(title)
        """
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
