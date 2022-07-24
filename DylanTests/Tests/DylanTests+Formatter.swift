//
//  DylanTests+Formatter.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/07/2022.
//

@testable import Greasy_Trail
import XCTest

extension DylanTests {
    
    func testFormatterFormatsDateToStringCorrectly() {
        let date = 0.0
        let expected = "January 1, 1970"
        XCTAssertEqual(expected, formatter.dateString(of: date))
    }
    
    func testFormatterFormatsStringToDateCorrectly() {
        let string = "January 1 1970"
        let expected = 0.0
        XCTAssertEqual(expected, formatter.date(from: string))
    }
    
    func testFormatterFormatsPerformanceCorrectly() {
        let formatted = formatter.formatted(performance: DummyModel.pNewport1965)
        let expected = "Newport Folk Festival (July 25, 1965)"
        XCTAssertEqual(expected, formatted)
    }
    
    func testFormatterReturnsUnknownWithNilDate() {
        let expected = "Unknown date"
        XCTAssertEqual(formatter.dateString(of: nil), expected)
    }
    
}
