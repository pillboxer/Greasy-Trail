//
//  Album.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import Foundation

// swiftlint:disable type_name
public struct sAlbum: Codable, Equatable, Identifiable {

    let uuid: String
    public let title: String
    let songs: [sSong]
    public let releaseDate: Double

    public var id: String {
        title + String(releaseDate)
    }
    
    public init(uuid: String, title: String, songs: [sSong], releaseDate: Double) {
        self.uuid = uuid
        self.title = title
        self.songs = songs
        self.releaseDate = releaseDate
    }

}

extension sAlbum {

   public func contains(_ song: sSong) -> Bool {
        songs.contains { $0 == song }
    }

}
extension sAlbum: Hashable {}
