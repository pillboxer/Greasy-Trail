//
//  DummyModel+Performances.swift
//  DylanTests
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
@testable import Dylan
extension DummyModel {
    
    static var tNewport1965: String {
        "Newport Folk Festival"
    }
     
    static var dNewport1965: Double {
        -140054400
    }
    
    static var lbNewport1965: [Int] {
        [2575,
         3174,
         10343,
         11949,
         12033,
         12095,
         12096]
    }
    
    static var pNewport1965: sPerformance {
        sPerformance(venue: tNewport1965, songs: [sMaggiesFarm, sItTakesALotToLaugh, sDesolationRow], date: dNewport1965)
    }

}
