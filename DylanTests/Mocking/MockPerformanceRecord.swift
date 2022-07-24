//
//  MockPerformanceRecord.swift
//  DylanTests
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
import CloudKit
@testable import Greasy_Trail

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
        switch field {
        case .lbNumbers:
            return lbNumbers
        default:
            return nil
        }
    }

    func string(for field: DylanRecordField) -> String? {
        switch field {
        case .venue:
            return venue
        default:
            return nil
        }
    }

    func double(for field: DylanRecordField) -> Double? {
        switch field {
        case .date:
            return date
        default:
            return nil
        }
    }

    func references(of referenceType: DylanReferenceType) -> [ReferenceType] {
        references
    }

}
