import Search
import Model
import AllPerformances
import GTCloudKit
import Add
import BottomBar
import CoreData
import Stats
import Core

struct AppState: Equatable {
    
    // Bottom Bar
    var isSearchFieldShowing = false
    var displayedView: DisplayedView = .home
    var displayedFavorite: Bool?
    var searchFieldText = ""

    // Search
    var model: AnyModel?
    var failedSearch: Search?
    var currentSearch: Search?
    var selectedID: ObjectIdentifier?
    var selectedObjectID: NSManagedObjectID?
    var isSearching = false

    // CloudKit
    var mode: Mode?
    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?
    var showingError = false
    
    // AllPerformances
    var selectedPerformancePredicate: PerformancePredicate = .sixties
    
    // Stats
    var isFetchingMissingLBCount = false
    var missingLBNumbers: [Int]?
    
    // Logs
    var isFetchingLogs = false
}
