//
//  Song.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

// swiftlint:disable type_name
public struct sSong: Codable {
    
    let uuid: String
    let title: String
    var author: String
    var performances: [sPerformance]?
    var albums: [sAlbum]?
}

extension sSong: Equatable {

    public static func == (lhs: sSong, rhs: sSong) -> Bool {
        lhs.title == rhs.title
    }

}

extension sSong: Identifiable, Hashable {

    public var id: String {
        title
    }

}
