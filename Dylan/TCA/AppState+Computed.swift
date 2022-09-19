import Search
import Add
import BottomBar
import TopBar
import GTCloudKit
import AllPerformances
import Stats

extension AppState {
    
    var search: SearchState {
        get {
            return SearchState(model: model,
                               displayedView: displayedView,
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
            displayedView = newValue.displayedView
            selectedObjectID = newValue.selectedObjectID
            isSearching = newValue.isSearching
        }
    }
    
    var addState: AddState {
        get {
            return AddState(searchState: search,
                     displayedView: displayedView)
        }
        set {
            self.search = newValue.search
            displayedView = newValue.displayedView
        }
    }
    
    var bottomBarState: BottomBarState {
        get {
            return BottomBarState(
                isSearchFieldShowing: isSearchFieldShowing,
                search: search,
                displayedView: displayedView,
                cloudKit: cloudKitState,
            displayedFavorite: displayedFavorite)
        }
        set {
            self.displayedView = newValue.displayedView
            self.search = newValue.searchState
            self.isSearchFieldShowing = newValue.isSearchFieldShowing
            self.cloudKitState = newValue.cloudKit
            self.displayedFavorite = newValue.displayedFavorite
        }
    }
    
    var allPerformancesState: AllPerformancesState {
        get {
            return AllPerformancesState(search: search, selectedPerformancePredicate: selectedPerformancePredicate)
        }
        set {
            search = newValue.search
            selectedPerformancePredicate = newValue.selectedPerformancePredicate
        }
    }
    
    var cloudKitState: CloudKitState {
        get {
            return CloudKitState(mode: mode, lastFetchDate: lastFetchDate)
        }
        set {
            mode = newValue.mode
            lastFetchDate = newValue.lastFetchDate
        }
    }
    
    var topBarState: TopBarState {
        get {
            return TopBarState(cloudKitState: cloudKitState, showingCloudKitError: showingCloudKitError)
        }
        set {
            showingCloudKitError = newValue.showingCloudKitError
            cloudKitState = newValue.cloudKit
        }
    }
    
    var statsState: StatsState {
        get {
            return StatsState(displayedView: displayedView,
            isFetchingMissingLBCount: isFetchingMissingLBCount,
            missingLBNumbers: missingLBNumbers)
        }
        set {
            displayedView = newValue.displayedView
            isFetchingMissingLBCount = newValue.isFetchingMissingLBCount
            missingLBNumbers = newValue.missingLBNumbers
        }
    }
    
}
