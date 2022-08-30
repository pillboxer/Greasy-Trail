//
//  SongDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import Foundation

/// The Information Returned Upon Requesting Information About A Song
public struct SongDisplayModel: Model {

    private let song: sSong
    public let uuid: String
    
    public init(song: sSong) {
        self.song = song
        self.uuid = song.uuid
    }
    
    public var uploadAllowed: Bool {
        uuid != .invalid
    }

}

public extension SongDisplayModel {

    var title: String {
        song.title
    }

    var author: String {
        song.author
    }

    var performances: [sPerformance]? {
        song.performances
    }

    var firstPerformance: sPerformance? {
        performances?.first
    }

}

extension SongDisplayModel: Equatable {

}
