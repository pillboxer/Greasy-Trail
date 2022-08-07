//
//  AllPerformancesState.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 04/08/2022.
//

import Combine
import GTCoreData

class AllPerformancesState: ObservableObject {
    
    @Published var selection: Set<Performance.ID> = []
    
}
