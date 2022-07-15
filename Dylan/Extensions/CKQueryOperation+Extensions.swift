//
//  CKQueryOperation+Extensions.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 15/07/2022.
//

import CloudKit

extension CKQueryOperation {
    convenience init(cursor: CKQueryOperation.Cursor?, query: CKQuery) {
        if let cursor = cursor {
            self.init(cursor: cursor)
        }
        else {
            self.init(query: query)
        }
    }
}
