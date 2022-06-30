//
//  RecordType.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

protocol RecordType {
    func references(of referenceType: DylanReferenceType) -> [ReferenceType]
    func reference(of referenceType: DylanReferenceType) -> ReferenceType?
    var recordID: CKRecord.ID { get }
    func string(for field: DylanRecordField) -> String?
    func double(for field: DylanRecordField) -> Double?
}
