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
import GTCloudKit
import Add

class AppState: ObservableObject {
    
    @Published var selection: Set<ObjectIdentifier> = []
    @Published var selectedRecordToAdd: DylanRecordType = .song
    @Published var model: AnyModel?
    @Published var failedSearch: Search?
    @Published var currentSearch: Search?
    
}

extension AppState {
    
    var songDisplayModel: SongDisplayModel? {
        model?.value as? SongDisplayModel
    }
    
    var performanceDisplayModel: PerformanceDisplayModel? {
        model?.value as? PerformanceDisplayModel
    }
    
    var albumDisplayModel: AlbumDisplayModel? {
        model?.value as? AlbumDisplayModel
    }
    
}

extension AppState {
    
    var tableListState: TableListState {
        get {
            TableListState(ids: selection, model: model, failedSearch: failedSearch)
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
    
    var addState: AddState {
        get {
            AddState(selectedRecordToAdd: selectedRecordToAdd)
        }
        set {
            self.selectedRecordToAdd = newValue.selectedRecordToAdd
        }
    }
}
