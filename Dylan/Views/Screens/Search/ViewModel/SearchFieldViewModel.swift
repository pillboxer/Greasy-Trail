//
//  SearchFieldViewModel.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 28/07/2022.
//

import Combine

class SearchFieldViewModel: ObservableObject {
    
    private let cloudKitManager: CloudKitManager
    
    init(cloudKitManager: CloudKitManager) {
        self.cloudKitManager = cloudKitManager
    }
    
    
    
}

