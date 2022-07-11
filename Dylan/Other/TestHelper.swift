//
//  TestHelper.swift
//  Dylan
//
//  Created by Henry Cooper on 11/07/2022.
//

import Foundation

class TestHelper: NSObject {
    static var isRunningTests: Bool {
       ProcessInfo.processInfo.environment["XCTestSessionIdentifier"] != nil
    }
}
