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

// State
public struct BottomBarState: Equatable {
    public var isSearchFieldShowing: Bool
    public var isSearching: Bool
    public var model: AnyModel?
    public var searchState: SearchState
    
    public init(searchState: SearchState,
                isSearchFieldShowing: Bool,
                isSearching: Bool,
                model: AnyModel?) {
        self.searchState = searchState
        self.isSearchFieldShowing = isSearchFieldShowing
        self.isSearching = isSearching
        self.model = model
    }
    
    public var bottomBarViewState: BottomBarViewState {
        get {
            BottomBarViewState(isSearchFieldShowing: isSearchFieldShowing,
                           isSearching: isSearching,
                           model: model)
        }
        set {
            isSearching = newValue.isSearching
            model = newValue.model
            isSearchFieldShowing = newValue.isSearchFieldShowing
        }
    }
}

public struct BottomBarViewState: Equatable {
    public var isSearchFieldShowing: Bool
    public var isSearching: Bool
    public var model: AnyModel?
    
    public init(isSearchFieldShowing: Bool,
                isSearching: Bool,
                model: AnyModel?) {
        self.model = model
        self.isSearchFieldShowing = isSearchFieldShowing
        self.isSearching = isSearching
    }
}

// Action

enum BottomViewAction {
    case reset
    case toggleSearchField
    case makeRandomSearch
}

public enum BottomBarFeatureAction {
    case bottom(BottomBarAction)
    case search(SearchAction)
}

public enum BottomBarAction {
    case toggleSearchField
}

public let bottomBarFeatureReducer: Reducer<BottomBarState, BottomBarFeatureAction, SearchEnvironment> =
combine(
    pullback(
        bottomBarReducer,
        value: \.bottomBarViewState,
        action: /BottomBarFeatureAction.bottom,
        environment: { _ in ()}),
    pullback(searchReducer,
             value: \.searchState,
             action: /BottomBarFeatureAction.search,
             environment: { $0 }))

public func bottomBarReducer(state: inout BottomBarViewState,
                             action: BottomBarAction,
                             environment: Void) -> [Effect<BottomBarAction>] {
    switch action {
    case .toggleSearchField:
        state.isSearchFieldShowing.toggle()
        return []
    }
}
