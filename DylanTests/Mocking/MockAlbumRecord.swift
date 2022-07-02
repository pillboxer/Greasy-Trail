//
//  MockAlbumRecord.swift
//  DylanTests
//
//  Created by Henry Cooper on 02/07/2022.
//

import Foundation
@testable import Dylan
import CloudKit
struct MockAlbumRecord: RecordType, CustomStringConvertible {
    
    let title: String
    let releaseDate: Double
    let recordName = UUID().uuidString
    
    init(title: String, releaseDate: Double) {
        self.title = title
        self.releaseDate = releaseDate
    }
    
    func string(for field: DylanRecordField) -> String? {
        switch field {
        case .title:
            return title
        default:
            return nil
        }
    }
    
    func double(for field: DylanRecordField) -> Double? {
        switch field {
        case .releaseDate:
            return releaseDate
        default:
            return nil
        }
    }
    
    // For the moment returning no songs
    func references(of referenceType: Dylan.DylanReferenceType) -> [Dylan.ReferenceType] {
        []
    }
    
    func reference(of referenceType: DylanReferenceType) -> ReferenceType? {
        nil
    }
        
    var recordID: CKRecord.ID { CKRecord.ID(recordName: recordName) }

    var description: String {
        """
        album title: \(title)
        """
    }
    
    
}
