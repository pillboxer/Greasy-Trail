//
//  Data+Extensions.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//

import Foundation

extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}
