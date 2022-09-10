//
//  AllPerformances+State.swift
//  AllPerformances
//
//  Created by Henry Cooper on 11/09/2022.
//

import Foundation
import Search

public struct AllPerformancesState: Equatable {
    public var search: SearchState
    public var selectedPerformanceDecade: PerformanceDecade
    
    public init(search: SearchState, selectedPerformanceDecade: PerformanceDecade) {
        self.search = search
        self.selectedPerformanceDecade = selectedPerformanceDecade
    }
}

struct AllPerformancesViewState: Equatable {
    var selectedID: ObjectIdentifier?
    var selectedDecade: PerformanceDecade
}

public enum PerformanceDecade: String, CaseIterable, Equatable {
    case sixties = "1960s"
    case seventies = "1970s"
    case eighties = "1980s"
    case nineties = "1990s"
    case noughties = "2000s"
    case twentytens = "2010s"
    case twentytwenties = "2020s"
    
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
        }
        return NSPredicate(format: "date >= %f AND date <= %f", after, before)
    }
}
