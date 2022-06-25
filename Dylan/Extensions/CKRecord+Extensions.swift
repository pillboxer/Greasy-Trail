//
//  CKRecord+Extensions.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

extension CKRecord: RecordType {
    
    func references(of referenceType: DylanReferenceType) -> [CKRecord.Reference] {
        retrieve(type: [CKRecord.Reference].self, of: referenceType, defaultType: [])
    }

    private func retrieve<T>(type: T.Type, of referenceType: DylanReferenceType, defaultType: T) -> T {
        self[referenceType.rawValue] as? T ?? defaultType
    }
}
