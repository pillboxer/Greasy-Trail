import Search
import Add
import BottomBar
import GTCloudKit
import AllPerformances
import TopBar
import Stats
import AllSongs
import AllAlbums
import Payments

enum AppAction {
    case search(SearchAction)
    case add(AddAction)
    case bottomBar(BottomBarFeatureAction)
    case cloudKit(CloudKitAction)
    case allPerformances(AllPerformancesFeatureAction)
    case allSongs(AllSongsFeatureAction)
    case allAlbums(AllAlbumsFeatureAction)
    case topBar(TopBarFeatureAction)
    case stats(StatsFeatureAction)
    case commandMenu(CommandMenuAction)
    case payments(PaymentsFeatureAction)
    
}
