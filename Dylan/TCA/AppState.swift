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
import Core

struct AppState: Equatable {

    // Bottom Bar
    var selectedRecordToAdd: DylanWork = .songs
    var isSearchFieldShowing = false
    var selectedSection: BottomBarSection = .home(.songs)
    // Navigation
    var selectedSidebarType: SidebarDisplayType = .songs
    // Search
    var model: AnyModel?
    var failedSearch: Search?
    var currentSearch: Search?
    var selectedID: ObjectIdentifier?
    var selectedObjectID: NSManagedObjectID?
    var isSearching = false
    // CloudKit
    var downloadingRecordType: DylanRecordType?
    var mode: Mode = .notDownloaded
    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?
    
    // AllPerformances
    var selectedPerformanceDecade: PerformanceDecade = .sixties

}

extension AppState {
    
    var search: SearchState {
        get {
            return SearchState(model: model,
                               failedSearch: failedSearch,
                               currentSearch: currentSearch,
                               selectedID: selectedID,
                               selectedObjectID: selectedObjectID,
                               isSearching: isSearching)
        }
        set {
            selectedID = newValue.selectedID
            model = newValue.model
            failedSearch = newValue.failedSearch
            currentSearch = newValue.currentSearch
            selectedObjectID = newValue.selectedObjectID
            isSearching = newValue.isSearching
        }
    }
    
    var addState: AddState {
        get {
            return AddState(searchState: search,
                     selectedRecordToAdd: selectedRecordToAdd)
        }
        set {
            self.search = newValue.search
            selectedRecordToAdd = newValue.selectedRecordToAdd
        }
    }
    
    var bottomBarState: BottomBarState {
        get {
            return BottomBarState(
                selectedSection: selectedSection,
                selectedRecordToAdd: selectedRecordToAdd,
                isSearchFieldShowing: isSearchFieldShowing,
                search: search)
        }
        set {
            self.selectedSection = newValue.selectedSection
            self.search = newValue.search
            if (search.model?.value as? PerformanceDisplayModel) != nil {
                self.selectedRecordToAdd = .performances
            } else if (search.model?.value as? AlbumDisplayModel) != nil {
                self.selectedRecordToAdd = .albums
            } else if (search.model?.value as? SongDisplayModel) != nil {
                self.selectedRecordToAdd = .songs
            } else {
                selectedRecordToAdd = newValue.selectedRecordToAdd
            }
            self.isSearchFieldShowing = newValue.isSearchFieldShowing
        }
    }
    
    var allPerformancesState: AllPerformancesState {
        get {
            return AllPerformancesState(search: search, selectedPerformanceDecade: selectedPerformanceDecade)
        }
        set {
            search = newValue.search
            selectedPerformanceDecade = newValue.selectedPerformanceDecade
        }
    }
    
    var cloudKitState: CloudKitState {
        get {
            return CloudKitState(downloadingRecordType: downloadingRecordType,
                                 mode: mode,
                                 lastFetchDate: lastFetchDate)
        }
        set {
            downloadingRecordType = newValue.downloadingRecordType
            mode = newValue.mode
            lastFetchDate = newValue.lastFetchDate
        }
    }
}
