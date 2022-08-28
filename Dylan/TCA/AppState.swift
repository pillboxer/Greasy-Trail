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
import GTCloudKit
import Add
import Sidebar

struct AppState: Equatable {
    var selectedModel: Set<ObjectIdentifier> = []
    var selectedRecordToAdd: DylanRecordType = .song
    var selectedSidebarType: SidebarDisplayType = .songs
    var model: AnyModel?
    var failedSearch: Search?
    var currentSearch: Search?
    var isSearching = false
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
    
    var searchState: SearchState {
        get {
            SearchState(model: model,
                        failedSearch: failedSearch,
                        currentSearch: currentSearch,
                        ids: selectedModel,
                        isSearching: isSearching)
        }
        set {
            self.failedSearch = newValue.failedSearch
            self.model = newValue.model
            self.currentSearch = newValue.currentSearch
            self.selectedModel = newValue.ids
            self.isSearching = newValue.isSearching
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
