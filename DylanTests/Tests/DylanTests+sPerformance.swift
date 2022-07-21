//
//  DylanTests+sPerformance.swift
//  DylanTests
//
//  Created by Henry Cooper on 16/07/2022.
//

@testable import Greasy_Trail
import XCTest

extension DylanTests {

    func testSPerformanceIDIsCorrect() {
        let expectedID = "Venue999.0"
        let sPerformance = sPerformance(venue: "Venue", songs: [], date: 999)
        XCTAssert(sPerformance.id == expectedID)
    }

    func testSPerformanceIDIsCorrectWithoutDate() {
        let expectdID = "Venue0.0"
        let sPerformance = sPerformance(venue: "Venue", songs: [], date: nil)
        XCTAssert(sPerformance.id == expectdID)

    }
}
