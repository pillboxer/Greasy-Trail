//
//  MockAlbumRecord.swift
//  DylanTests
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation
@testable import Greasy_Trail
import CloudKit

struct MockAlbumRecord: CustomStringConvertible {
    
    let title: String
    let releaseDate: Double
    let recordName = UUID().uuidString
    let references: [ReferenceType]
    
    init(title: String, releaseDate: Double, references: [ReferenceType]) {
        self.title = title
        self.releaseDate = releaseDate
        self.references = references
    }
    
    var description: String {
        """
        album title: \(title)
        """
    }
    
    
}

extension MockAlbumRecord: MockRecordType {
    
    func ints(for field: DylanRecordField) -> [Int]? {
        nil
    }
    
    var modificationDate: Date? {
        .distantPast
    }
    
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }
    
    func references(of referenceType: DylanReferenceType) -> [ReferenceType] {
        references
    }
    
    func asReferenceType() -> MockReferenceType {
        MockReferenceType(title: title, recordID: recordID)
    }
    
    func data(for field: DylanRecordField) -> Data? {
        nil
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
}
