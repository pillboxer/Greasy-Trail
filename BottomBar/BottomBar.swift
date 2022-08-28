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

public struct BottomBarState: Equatable {
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

public enum BottomBarAction {
    case toggleSearchField
}

public struct BottomBarFeatureState {
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
    
    public var bottomBarState: BottomBarState {
        get {
            BottomBarState(isSearchFieldShowing: isSearchFieldShowing,
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

public enum BottomBarFeatureAction {
    case bottom(BottomBarAction)
    case search(SearchAction)
}

public let bottomBarFeatureReducer: Reducer<BottomBarFeatureState, BottomBarFeatureAction, SearchEnvironment> =
combine(
    pullback(
        bottomBarReducer,
        value: \.bottomBarState,
        action: /BottomBarFeatureAction.bottom,
        environment: { _ in ()}),
    pullback(searchReducer,
             value: \.searchState,
             action: /BottomBarFeatureAction.search,
             environment: { $0 }))

public func bottomBarReducer(state: inout BottomBarState,
                             action: BottomBarAction,
                             environment: Void) -> [Effect<BottomBarAction>] {
    switch action {
    case .toggleSearchField:
        state.isSearchFieldShowing.toggle()
        return []
    }
}
