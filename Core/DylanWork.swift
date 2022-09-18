//
//  DylanWork.swift
//  Core
//
//  Created by Henry Cooper on 14/09/2022.
//

import Foundation

public enum DylanWork: String, Equatable {
    case songs
    case albums
    case performances
    
    public var imageName: String {
        switch self {
        case .songs:
            return "waveform.circle"
        case .albums:
            return "record.circle"
        case .performances:
            return "music.mic.circle"
        }
    }
}
