//
//  BottomBar.swift
//  BottomBar
//
//  Created by Henry Cooper on 28/08/2022.
//

import ComposableArchitecture
import Search
import CasePaths
import Model
import Core
import GTCloudKit
import CoreData

// State
public struct BottomBarState: Equatable {
    
    // Bottom Bar
    public var selectedSection: BottomBarSection
    public var isSearchFieldShowing: Bool
    public var selectedRecordToAdd: DylanWork
    
    // Search
    public var search: SearchState
  
    public init(selectedSection: BottomBarSection,
                selectedRecordToAdd: DylanWork,
                isSearchFieldShowing: Bool,
                search: SearchState) {
        self.selectedSection = selectedSection
        self.selectedRecordToAdd = selectedRecordToAdd
        self.isSearchFieldShowing = isSearchFieldShowing
        self.search = search

    }
}

public struct BottomBarViewState: Equatable {
    
    public var isSearchFieldShowing: Bool
    public var isSearching: Bool
    public var model: AnyModel?
    public var selectedSection: BottomBarSection
    public var selectedRecordToAdd: DylanWork
    public var selectedObjectID: NSManagedObjectID?
    
    public init(isSearchFieldShowing: Bool,
                isSearching: Bool,
                model: AnyModel?,
                selectedSection: BottomBarSection,
                selectedObjectID: NSManagedObjectID?,
                selectedRecordToAdd: DylanWork) {
        self.model = model
        self.isSearchFieldShowing = isSearchFieldShowing
        self.isSearching = isSearching
        self.selectedSection = selectedSection
        self.selectedRecordToAdd = selectedRecordToAdd
        self.selectedObjectID = selectedObjectID
    }
}

// Action
public struct BottomBarEnvironment {
    let search: SearchEnvironment
    
    public init(search: SearchEnvironment) {
        self.search = search
    }
}

enum BottomViewAction {
    case reset
    case toggleSearchField
    case makeRandomSearch
    case selectSection(BottomBarSection)
    case selectRecordToAdd(DylanWork)
    case search(NSManagedObjectID)
}

public enum BottomBarFeatureAction {
    case bottom(BottomBarAction)
    case search(SearchAction)
}

public enum BottomBarAction {
    case toggleSearchField
    case selectSection(BottomBarSection)
    case selectRecordToAdd(DylanWork)
}

public let bottomBarFeatureReducer: Reducer<BottomBarState, BottomBarFeatureAction, BottomBarEnvironment> =
Reducer.combine(
    bottomBarReducer.pullback(
        state: \.self,
        action: /BottomBarFeatureAction.bottom,
        environment: { _ in ()}),
    searchReducer.pullback(
        state: \.search,
        action: /BottomBarFeatureAction.search,
        environment: { $0.search }))

public let bottomBarReducer = Reducer<BottomBarState, BottomBarAction, Void> { state, action, _ in
    switch action {
    case .toggleSearchField:
        state.isSearchFieldShowing.toggle()
    case .selectSection(let section):
        state.selectedSection = section
    case .selectRecordToAdd(let record):
        state.selectedRecordToAdd = record
    }
    return .none
}
