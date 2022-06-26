//
//  CKRecord+Extensions.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

extension CKRecord: RecordType {
    
    func references(of referenceType: DylanReferenceType) -> [ReferenceType] {
        retrieve(type: [CKRecord.Reference].self, fromPath: referenceType.rawValue, defaultType: [])
    }
    
    func referenceName(for parameter: String) -> String? {
        (self[parameter] as? CKRecord.Reference)?.recordID.recordName
    }
    
    func string(for field: DylanRecordField) -> String {
        retrieve(type: String.self, fromPath: field.rawValue, defaultType: "")
    }
    
    private func retrieve<T>(type: T.Type, fromPath path: String, defaultType: T) -> T {
        self[path] as? T ?? defaultType
    }
}

extension CKRecord.Reference: ReferenceType {}
