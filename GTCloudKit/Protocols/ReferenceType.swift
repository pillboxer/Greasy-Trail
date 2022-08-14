//
//  ReferenceType.swift
//  Dylan
//
//  Created by Henry Cooper on 26/06/2022.
//

import CloudKit

public protocol ReferenceType {

    var recordID: CKRecord.ID { get }

}
