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
import BottomBar
import CoreData

struct AppState: Equatable {
    
    // Selection
    var selectedID: ObjectIdentifier?
    var selectedObjectID: NSManagedObjectID?

    // Bottom Bar
    var selectedSection: BottomBarSection = .home
    var selectedRecordToAdd: DylanRecordType = .song

    // Navigation
    var selectedSidebarType: SidebarDisplayType = .songs
    
    // Search
    var failedSearch: Search?
    var currentSearch: Search?
    var isSearching = false
    var isSearchFieldShowing = false
    var model: AnyModel?
    
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
                        selectedID: selectedID,
                        selectedObjectID: selectedObjectID,
                        selectedRecordToAdd: selectedRecordToAdd,
                        isSearching: isSearching)
        }
        set {
            self.failedSearch = newValue.failedSearch
            self.model = newValue.model
            self.currentSearch = newValue.currentSearch
            self.selectedID = newValue.selectedID
            self.isSearching = newValue.isSearching
            self.selectedObjectID = newValue.selectedObjectID
            self.selectedRecordToAdd = newValue.selectedRecordToAdd
        }
    }
    
    var addState: AddState {
        get {
            AddState(model: model, selectedRecordToAdd: selectedRecordToAdd)
        }
        set {
            self.selectedRecordToAdd = newValue.selectedRecordToAdd
            self.model = newValue.model
        }
    }
    
    var bottomBarState: BottomBarState {
        get {
            return BottomBarState(isSearchFieldShowing: isSearchFieldShowing,
                                  isSearching: isSearching,
                                  model: model,
                                  selectedSection: selectedSection,
                                  selectedObjectID: selectedObjectID,
                                  selectedRecordToAdd: selectedRecordToAdd,
                                  selectedID: selectedID)
        }
        set {
            self.isSearchFieldShowing = newValue.isSearchFieldShowing
            self.selectedSection = newValue.selectedSection
            self.selectedRecordToAdd = newValue.selectedRecordToAdd
            self.model = newValue.model
            self.selectedObjectID = newValue.selectedObjectID
            self.selectedID = newValue.selectedID
        }
    }
}
