//
//  Performance.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

// swiftlint:disable type_name
struct sPerformance: Codable, Editable {

    let uuid: String
    let venue: String
    let songs: [sSong]
    let date: Double?
    var lbNumbers: [Int]?

    var id: String {
        venue + String(date ?? 0)
    }

}

extension sPerformance: Hashable {}
