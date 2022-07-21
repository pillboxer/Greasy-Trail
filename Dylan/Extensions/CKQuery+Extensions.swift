//
//  CKQuery+Extensions.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

extension CKQuery {

    convenience init (recordType: DylanRecordType, predicate: NSPredicate = .init(value: true)) {
        self.init(recordType: recordType.rawValue, predicate: predicate)
    }

}
