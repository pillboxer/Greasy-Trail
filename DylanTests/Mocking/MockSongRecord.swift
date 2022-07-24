//
//  MockSongRecord.swift
//  DylanTests
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation
@testable import Greasy_Trail
import CloudKit

class MockSongRecord {

    private let recordName = UUID().uuidString
    let title: String

    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }

    init(title: String) {
        self.title = title
    }
}

extension MockSongRecord: CustomStringConvertible {

    var description: String {
        """
            song title: \(title)
        """
    }

}

extension MockSongRecord: RecordType {

    var modificationDate: Date? {
        .distantPast
    }

    func string(for field: DylanRecordField) -> String? {
        switch field {
        case .title:
            return title
        default:
            return nil
        }
    }
}

extension MockSongRecord: MockRecordType {

    func asReferenceType() -> MockReferenceType {
        MockReferenceType(title: title, recordID: recordID)
    }

}
