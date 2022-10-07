import ComposableArchitecture
import GTCoreData
import Search
import GTCloudKit
import CoreData

private struct TimerID: Hashable {}

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
    case .displayFavoriteResult(let result):
        logger.log("Setting favorite to \(result?.description ?? "nil", privacy: .public)")
        state.displayedFavorite = result
    case .toggleSearchField:
        logger.log("Toggle search field")
        state.isSearchFieldShowing.toggle()
    case .resetFavoriteResult:
        logger.log("Resetting favorite result")
        state.displayedFavorite = nil
    case .selectDisplayedView(let displayedView):
        logger.log("Setting displayed view to \(displayedView.rawValue, privacy: .public)")
        state.displayedView = displayedView
        return Effect(value: .resetFavoriteResult)
    case .toggleFavorite:
        let uuid = state.searchState.model?.uuid
        return .run { send in
            guard let uuid = uuid else { return }
            let context = PersistenceController.shared.newBackgroundContext()
            let predicate = NSPredicate(format: "uuid = %@", uuid)
            let songFetch: NSFetchRequest<Song> = Song.fetchRequest()
            let albumFetch: NSFetchRequest<Album> = Album.fetchRequest()
            let performanceFetch: NSFetchRequest<Performance> = Performance.fetchRequest()
            
            songFetch.predicate = predicate
            albumFetch.predicate = predicate
            performanceFetch.predicate = predicate
            var newResult: Bool?
            await context.perform {
                let songs = (try? context.fetch(songFetch) as [Favoritable]) ?? []
                let albums = (try? context.fetch(albumFetch) as [Favoritable]) ?? []
                let performances = (try? context.fetch(performanceFetch) as [Favoritable]) ?? []

                let object = [songs, albums, performances].flatMap { $0 }.first
                object?.isFavorite.toggle()
                logger.log("Toggled favorite to \(object?.isFavorite.description ?? "nil", privacy: .public)")
                newResult = object?.isFavorite
            }
            await context.asyncSave()
            await send(.displayFavoriteResult(newResult))
        }
    }
    return .none
}
