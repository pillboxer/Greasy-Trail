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
    public var selectedRecordToAdd: DylanWork
    
    // Search
    public var search: SearchState
    
    public var cloudKit: CloudKitState
  
    public init(selectedRecordToAdd: DylanWork,
                isSearchFieldShowing: Bool,
                search: SearchState,
                cloudKit: CloudKitState) {
        self.selectedRecordToAdd = selectedRecordToAdd
        self.isSearchFieldShowing = isSearchFieldShowing
        self.search = search
        self.cloudKit = cloudKit
    }
}

public struct BottomBarViewState: Equatable {
    
    public var isSearchFieldShowing: Bool
    public var isSearching: Bool
    public var model: AnyModel?
    public var displayedView: DisplayedView
    public var selectedRecordToAdd: DylanWork
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
    case selectRecordToAdd(DylanWork)
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
        environment: { $0.search }),
    cloudKitReducer.pullback(
        state: \.cloudKit,
        action: /BottomBarFeatureAction.cloudKit,
        environment: { $0.cloudKit }))

public let bottomBarReducer = Reducer<BottomBarState, BottomBarAction, Void> { state, action, _ in
    switch action {
    case .toggleSearchField:
        state.isSearchFieldShowing.toggle()
    case .selectRecordToAdd(let record):
        state.selectedRecordToAdd = record
    }
    return .none
}
