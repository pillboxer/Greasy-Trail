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
    public var isSearchFieldShowing: Bool
    public var displayedView: DisplayedView
    // Search
    public var search: SearchState
    
    public var searchState: SearchState {
        get {
            SearchState(model: search.model,
                        displayedView: displayedView,
                        failedSearch: search.failedSearch,
                        currentSearch: search.currentSearch,
                        selectedID: search.selectedID,
                        selectedObjectID: search.selectedObjectID,
                        isSearching: search.isSearching)
        }
        set {
            self.search = newValue
            self.displayedView = newValue.displayedView
        }
    }
    
    public var cloudKit: CloudKitState
  
    public init(isSearchFieldShowing: Bool,
                search: SearchState,
                displayedView: DisplayedView,
                cloudKit: CloudKitState) {
        self.isSearchFieldShowing = isSearchFieldShowing
        self.search = search
        self.displayedView = displayedView
        self.cloudKit = cloudKit
    }
}

public struct BottomBarViewState: Equatable {
    
    public var isSearchFieldShowing: Bool
    public var isSearching: Bool
    public var model: AnyModel?
    public var displayedView: DisplayedView
    public var selectedObjectID: NSManagedObjectID?
}

public struct BottomBarEnvironment {
    let search: SearchEnvironment
    let cloudKit: CloudKitEnvironment
    
    public init(search: SearchEnvironment, cloudKit: CloudKitEnvironment) {
        self.search = search
        self.cloudKit = cloudKit
    }
}

enum BottomViewAction {
    case reset
    case toggleSearchField
    case makeRandomSearch
    case selectView(DisplayedView)
    case search(NSManagedObjectID)
    case upload(Model)
}

public enum BottomBarFeatureAction {
    case bottom(BottomBarAction)
    case search(SearchAction)
    case cloudKit(CloudKitAction)
}

public enum BottomBarAction {
    case toggleSearchField
    case selectDisplayedView(DisplayedView)
}

public let bottomBarFeatureReducer: Reducer<BottomBarState, BottomBarFeatureAction, BottomBarEnvironment> =
Reducer.combine(
    bottomBarReducer.pullback(
        state: \.self,
        action: /BottomBarFeatureAction.bottom,
        environment: { _ in ()}),
    searchReducer.pullback(
        state: \.searchState,
        action: /BottomBarFeatureAction.search,
        environment: { $0.search }),
    cloudKitReducer.pullback(
        state: \.cloudKit,
        action: /BottomBarFeatureAction.cloudKit,
        environment: { $0.cloudKit }))

public let bottomBarReducer = Reducer<BottomBarState, BottomBarAction, Void> { state, action, _ in
    switch action {
    case .toggleSearchField:
        state.isSearchFieldShowing.toggle()
    case .selectDisplayedView(let displayedView):
        state.displayedView = displayedView
    }
    return .none
}
