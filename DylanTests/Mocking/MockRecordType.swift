//
//  MockRecordType.swift
//  DylanTests
//
//  Created by Henry Cooper on 04/07/2022.
//

@testable import Greasy_Trail

protocol MockRecordType: RecordType {
    func asReferenceType() -> MockReferenceType
}

extension MockRecordType {

}
