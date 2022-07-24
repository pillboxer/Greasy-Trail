//
//  DummyModel+Metadata.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/07/2022.
//

import Foundation

// swiftlint: disable force_try
extension DummyModel {
    
    static var AppMetadataRecord: MockMetadataRecord {
        MockMetadataRecord(name: "misspellings", file: testJSON)
    }
    
    static var testJSON: Data {
        let bundle = Bundle(for: DylanTests.self)
        let path = bundle.path(forResource: "test_json", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        return try! Data(contentsOf: url)
    }
    
}
