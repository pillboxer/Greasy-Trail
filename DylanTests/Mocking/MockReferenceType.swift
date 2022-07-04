//
//  MockReferenceType.swift
//  DylanTests
//
//  Created by Henry Cooper on 04/07/2022.
//

@testable import Dylan
import CloudKit

class MockReferenceType: ReferenceType {
    
    let title: String
    let recordID: CKRecord.ID
    
    init(title: String, recordID: CKRecord.ID) {
        self.title = title
        self.recordID = recordID
    }
    
    
}
