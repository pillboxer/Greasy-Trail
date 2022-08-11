//
//  AppState.swift
//  AllPerformances
//
//  Created by Henry Cooper on 05/08/2022.
//

import Foundation
import Search
import Model
import AllPerformances
import TableList

class AppState: ObservableObject {
    
    var selection: Set<ObjectIdentifier> = []    
    @Published var model: Model?
    @Published var failedSearch: Search?
    @Published var currentSearch: Search? {
        didSet {
            print("NOW \(currentSearch)")
        }
    }
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

extension AppState {
    
    var tableListState: TableListState {
        get {
            TableListState(ids: self.selection, model: self.model, failedSearch: self.failedSearch)
        }
        set {
            self.selection = newValue.ids
            self.model = newValue.model
            self.failedSearch = newValue.failedSearch
        }
    }

    var searchState: SearchState {
        get {
            SearchState(model: model, failedSearch: failedSearch, currentSearch: currentSearch)
        }
        set {
            self.failedSearch = newValue.failedSearch
            self.model = newValue.model
            self.currentSearch = newValue.currentSearch
        }
    }
}
