//
//  AppState.swift
//  AllPerformances
//
//  Created by Henry Cooper on 05/08/2022.
//

import Foundation
import Search
import Model

class AppState: ObservableObject {
    var selection: Set<ObjectIdentifier> = []
    var nextSearch: Search?
    @Published var model: Model?
}

extension AppState {
    
    var songDisplayModel: SongDisplayModel? {
        model as? SongDisplayModel
    }
    
    var performanceDisplayModel: PerformanceDisplayModel? {
        model as? PerformanceDisplayModel
    }
    
    var albumDisplayModel: AlbumDisplayModel? {
        model as? AlbumDisplayModel
    }
    
}
