import Core
import Search
import CoreData
import GTCloudKit
import Model

public struct BottomBarEnvironment {
    let search: SearchEnvironment
    let cloudKit: CloudKitEnvironment
    
    public init(search: SearchEnvironment, cloudKit: CloudKitEnvironment) {
        self.search = search
        self.cloudKit = cloudKit
    }
}

enum BottomViewAction {
    case reset(DisplayedView)
    case toggleSearchField
    case makeRandomSearch
    case selectView(DisplayedView)
    case toggleFavorite
    case resetFavoriteResult
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
    case toggleFavorite
    case displayFavoriteResult(Bool?)
    case resetFavoriteResult
}
