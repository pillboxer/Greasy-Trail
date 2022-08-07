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
    public let title: String
    public var author: String
    var performances: [sPerformance]?
    var albums: [sAlbum]?
    
    public init(uuid: String,
                title: String,
                author: String = NSLocalizedString("default_author", comment: ""),
                performances: [sPerformance]? = nil,
                albums: [sAlbum]? = nil) {
        self.uuid = uuid
        self.title = title
        self.author = author
        self.performances = performances
        self.albums = albums
    }
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
