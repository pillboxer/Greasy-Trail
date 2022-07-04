//
//  MockRecordType.swift
//  DylanTests
//
//  Created by Henry Cooper on 04/07/2022.
//

@testable import Dylan

protocol MockRecordType: RecordType {
    func asReferenceType() -> MockReferenceType
}

extension MockRecordType {

}
