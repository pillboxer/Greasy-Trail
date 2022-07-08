//
//  MockPerformanceRecord.swift
//  DylanTests
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
import CloudKit
@testable import Dylan

class MockPerformanceRecord {
    
    let venue: String
    let date: Double
    let lbNumbers: [Int]
    let references: [ReferenceType]
    
    private let recordName = UUID().uuidString
    
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }

    init(venue: String, date: Double, lbNumbers: [Int], references: [ReferenceType]) {
        self.venue = venue
        self.date = date
        self.lbNumbers = lbNumbers
        self.references = references
    }
    
}

extension MockPerformanceRecord: RecordType {
    
    func ints(for field: DylanRecordField) -> [Int]? {
        lbNumbers
    }
    
    func string(for field: DylanRecordField) -> String? {
        venue
    }
    
    func double(for field: DylanRecordField) -> Double? {
        date
    }
    
    var modificationDate: Date? {
        .distantPast
    }
    
    func references(of referenceType: DylanReferenceType) -> [ReferenceType] {
        references
    }
    
}
