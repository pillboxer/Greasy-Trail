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
    
    public var isSearchFieldShowing: Bool
    public var isSearching: Bool
    public var model: AnyModel?
    public var selectedSection: BottomBarSection
    public var selectedRecordToAdd: DylanRecordType
    public var selectedObjectID: NSManagedObjectID?
    public var selectedID: ObjectIdentifier?
    
    public init(isSearchFieldShowing: Bool,
                isSearching: Bool,
                model: AnyModel?,
                selectedSection: BottomBarSection,
                selectedObjectID: NSManagedObjectID?,
                selectedRecordToAdd: DylanRecordType,
                selectedID: ObjectIdentifier?) {
        
        self.isSearchFieldShowing = isSearchFieldShowing
        self.isSearching = isSearching
        self.model = model
        self.selectedSection = selectedSection
        self.selectedRecordToAdd = selectedRecordToAdd
        self.selectedObjectID = selectedObjectID
        self.selectedID = selectedID
    }
    
    var bottomBarViewState: BottomBarViewState {
        get {
            BottomBarViewState(isSearchFieldShowing: isSearchFieldShowing,
                               isSearching: isSearching,
                               model: model,
                               selectedSection: selectedSection,
                               selectedObjectID: selectedObjectID,
                               selectedRecordToAdd: selectedRecordToAdd)
        }
        set {
            isSearching = newValue.isSearching
            model = newValue.model
            isSearchFieldShowing = newValue.isSearchFieldShowing
            selectedSection = newValue.selectedSection
        }
    }
    
    public var searchState: SearchState {
        get {
            return SearchState(model: model,
                               failedSearch: nil,
                               currentSearch: nil,
                               selectedID: selectedID,
                               selectedObjectID: selectedObjectID,
                               selectedRecordToAdd: selectedRecordToAdd,
                               isSearching: isSearching)
        }
        set {
            selectedRecordToAdd = newValue.selectedRecordToAdd
            isSearching = newValue.isSearching
            model = newValue.model
            selectedObjectID = newValue.selectedObjectID
            selectedID = newValue.selectedID
        }
    }
}

public struct BottomBarViewState: Equatable {
    public var isSearchFieldShowing: Bool
    public var isSearching: Bool
    public var model: AnyModel?
    public var selectedSection: BottomBarSection
    public var selectedRecordToAdd: DylanRecordType
    public var selectedObjectID: NSManagedObjectID?
    public init(isSearchFieldShowing: Bool,
                isSearching: Bool,
                model: AnyModel?,
                selectedSection: BottomBarSection,
                selectedObjectID: NSManagedObjectID?,
                selectedRecordToAdd: DylanRecordType
    ) {
        self.model = model
        self.isSearchFieldShowing = isSearchFieldShowing
        self.isSearching = isSearching
        self.selectedSection = selectedSection
        self.selectedRecordToAdd = selectedRecordToAdd
        self.selectedObjectID = selectedObjectID
    }
}

// Action

enum BottomViewAction {
    case reset
    case toggleSearchField
    case makeRandomSearch
    case selectSection(BottomBarSection)
    case selectRecordToAdd(DylanRecordType)
    case search(NSManagedObjectID)
}

public enum BottomBarFeatureAction {
    case bottom(BottomBarAction)
    case search(SearchAction)
}

public enum BottomBarAction {
    case toggleSearchField
    case selectSection(BottomBarSection)
    case selectRecordToAdd(DylanRecordType)
}

public let bottomBarFeatureReducer: Reducer<BottomBarState, BottomBarFeatureAction, SearchEnvironment> =
Reducer.combine(
    bottomBarReducer.pullback(
        state: \.self,
        action: /BottomBarFeatureAction.bottom,
        environment: { _ in ()}),
    searchReducer.pullback(
        state: \.searchState,
        action: /BottomBarFeatureAction.search,
        environment: { $0 }))

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
