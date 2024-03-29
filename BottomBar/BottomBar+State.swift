import Core
import GTCloudKit
import Search
import Model
import CoreData
public struct BottomBarState: Equatable {
    
    // Bottom Bar
    public var isSearchFieldShowing: Bool
    public var displayedView: DisplayedView
    public var displayedFavorite: Bool?
    var hasLoadedInAppPurchases: Bool
    var displaysAdminFunctionality: Bool
    
    // Search
    public var search: SearchState
    
    public var searchState: SearchState {
        get {
            SearchState(model: search.model,
                        displayedView: displayedView,
                        failedSearch: search.failedSearch,
                        currentSearch: search.currentSearch,
                        searchFieldText: search.searchFieldText,
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
                cloudKit: CloudKitState,
                displayedFavorite: Bool?,
                hasLoadedInAppPurchases: Bool,
                displaysAdminFunctionality: Bool) {
        self.isSearchFieldShowing = isSearchFieldShowing
        self.search = search
        self.displayedView = displayedView
        self.cloudKit = cloudKit
        self.displayedFavorite = displayedFavorite
        self.hasLoadedInAppPurchases = hasLoadedInAppPurchases
        self.displaysAdminFunctionality = displaysAdminFunctionality
    }
}

public struct BottomBarViewState: Equatable {
    public var displayedFavorite: Bool?
    public var isSearchFieldShowing: Bool
    public var isSearching: Bool
    public var model: AnyModel?
    public var displayedView: DisplayedView
    public var selectedObjectID: NSManagedObjectID?
    public var isDownloading: Bool
    public var hasLoadedInAppPurchases: Bool
    public var displaysAdminFunctionality: Bool
}
