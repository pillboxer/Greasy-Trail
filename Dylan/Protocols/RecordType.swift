//
//  RecordType.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

protocol RecordType {
    func references(of referenceType: DylanReferenceType) -> [CKRecord.Reference]
}
