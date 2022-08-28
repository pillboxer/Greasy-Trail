//
//  Sidebar.swift
//  Sidebar
//
//  Created by Henry Cooper on 15/08/2022.
//

import Foundation

public enum SidebarDisplayType: String, CaseIterable, Equatable {
    case songs = "Songs"
    case albums = "Albums"
    case performances = "Performances"
    
    case sixties = "1960s"
    case seventies = "1970s"
    case eighties = "1980s"
    case nineties = "1990s"
    case noughties = "2000s"
    case twentytens = "2010s"
    case twentytwenties = "2020s"
    
    public var children: [SidebarDisplayType]? {
        switch self {
        case .performances:
            return [.sixties, .seventies, .eighties, .nineties, .noughties, .twentytens, .twentytwenties]
        default:
            return nil
        }
    }
    
    public var predicate: NSPredicate {
        let after: TimeInterval
        let before: TimeInterval
        switch self {
        case .sixties:
            after = -315619200
            before = 0
        case .seventies:
            after = 0
            before = 315532800
        case .eighties:
            after = 315532800
            before = 631152000
        case .nineties:
            after = 631152000
            before = 946684800
        case .noughties:
            after = 946684800
            before = 1262304000
        case .twentytens:
            after = 1262304000
            before = 1577836800
        case .twentytwenties:
            after = 1577836800
            before = 1893456000
        default:
            return NSPredicate(value: true)
        }
        return NSPredicate(format: "date >= %f AND date <= %f", after, before)
    }
    
    public static var displayedTypes: [SidebarDisplayType] {
        [.songs, .albums, .performances]
    }
}
