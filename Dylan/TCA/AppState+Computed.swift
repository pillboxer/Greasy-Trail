import Search
import Add
import BottomBar
import TopBar
import GTCloudKit
import AllPerformances
import Stats
import AllSongs
import AllAlbums

extension AppState {
    
    var search: SearchState {
        get {
            return SearchState(
                model: model,
                displayedView: displayedView,
                failedSearch: failedSearch,
                currentSearch: currentSearch,
                searchFieldText: searchFieldText,
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
            searchFieldText = newValue.searchFieldText
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
            return AllPerformancesState(
                search: search,
                selectedPerformancePredicate: selectedPerformancePredicate)
        }
        set {
            search = newValue.search
            selectedPerformancePredicate = newValue.selectedPerformancePredicate
        }
    }
    
    var cloudKitState: CloudKitState {
        get {
            return CloudKitState(
                mode: mode,
                lastFetchDate: lastFetchDate)
        }
        set {
            mode = newValue.mode
            if let date = newValue.lastFetchDate {
                lastFetchDate = date
            }
        }
    }
    
    var topBarState: TopBarState {
        get {
            return TopBarState(cloudKitState: cloudKitState,
                               showingError: showingError,
                               isFetchingLogs: isFetchingLogs)
        }
        set {
            showingError = newValue.showingError
            cloudKitState = newValue.cloudKit
        }
    }
    
    var statsState: StatsState {
        get {
            return StatsState(displayedView: displayedView,
                              isFetchingMissingLBCount: isFetchingMissingLBCount,
                              missingLBNumbers: missingLBNumbers,
                              search: search)
        }
        set {
            isFetchingMissingLBCount = newValue.isFetchingMissingLBCount
            missingLBNumbers = newValue.missingLBNumbers
            search = newValue.search
            displayedView = newValue.displayedView
            
        }
    }
    
    var commandMenuState: CommandMenuState {
        get {
            CommandMenuState(mode: mode)
        }
        set {
            mode = newValue.mode
        }
    }
    
    var allSongsState: AllSongsState {
        get {
            AllSongsState(search: search,
                          selectedSongPredicate: selectedSongPredicate)
        }
        set {
            selectedSongPredicate = newValue.selectedSongPredicate
            search = newValue.search
        }
    }
    
    var allAlbumsState: AllAlbumsState {
        get {
            AllAlbumsState(search: search,
                           albumPredicate: selectedAlbumPredicate)
        }
        set {
            search = newValue.search
            selectedAlbumPredicate = newValue.albumPredicate
        }
    }
}
