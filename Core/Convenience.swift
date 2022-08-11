//
//  Convenience.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 30/07/2022.
//

import Foundation

public func delay(_ timeInterval: TimeInterval, action: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: action)
}

public func delay(_ timeInterval: TimeInterval) async {
    await withCheckedContinuation { continuation in
        delay(timeInterval) {
            continuation.resume()
        }
    }
}
