//
//  Dictionary+Extensions.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//

import Foundation

// swiftlint:disable identifier_name
extension Dictionary where Key == String {

    subscript(caseInsensitive key: Key) -> Value? {
        get {
            if let k = keys.first(where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                return self[k]
            }
            return nil
        }
        set {
            if let k = keys.first(where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                self[k] = newValue
            } else {
                self[key] = newValue
            }
        }
    }

}
