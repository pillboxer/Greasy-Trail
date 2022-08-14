//
//  RecordType.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

public protocol RecordType {
    var recordID: CKRecord.ID { get }
    func string(for field: DylanRecordField) -> String?
    func ints(for field: DylanRecordField) -> [Int]?
    func double(for field: DylanRecordField) -> Double?
    func data(for field: DylanRecordField) -> Data?
    func references(of referenceType: DylanReferenceType) -> [ReferenceType]
    var modificationDate: Date? { get }
}

extension RecordType {
    
    func string(for field: DylanRecordField) -> String? {
        nil
    }
    
    func ints(for field: DylanRecordField) -> [Int]? {
        nil
    }
    
    func double(for field: DylanRecordField) -> Double? {
        nil
    }
    
    func data(for field: DylanRecordField) -> Data? {
        nil
    }
    
    func references(of referenceType: DylanReferenceType) -> [ReferenceType] {
        []
    }
    
    var modificationDate: Date? {
        .distantPast
    }
    
}
