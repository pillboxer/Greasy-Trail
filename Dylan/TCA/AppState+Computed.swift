import Search
import Add
import BottomBar
import TopBar
import GTCloudKit
import AllPerformances

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
                cloudKit: cloudKitState)
        }
        set {
            self.displayedView = newValue.displayedView
            self.search = newValue.searchState
            if self.displayedView.isAdding {
                
            }
           
            self.isSearchFieldShowing = newValue.isSearchFieldShowing
            self.cloudKitState = newValue.cloudKit
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
}
