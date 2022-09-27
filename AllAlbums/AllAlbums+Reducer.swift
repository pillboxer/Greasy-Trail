import ComposableArchitecture
import Search

public let allAlbumsFeatureReducer: Reducer<AllAlbumsState,
                                           AllAlbumsFeatureAction,
                                           SearchEnvironment> =
Reducer.combine(
    searchReducer.pullback(
        state: \.search,
        action: /AllAlbumsFeatureAction.search,
        environment: { $0 }),
    allAlbumsReducer.pullback(
        state: \.self,
        action: /AllAlbumsFeatureAction.allAlbums,
        environment: { _ in () }))

let allAlbumsReducer = Reducer<AllAlbumsState, AllAlbumsAction, Void> { state, action, _ in
    switch action {
    case .selectAlbumPredicate(let predicate):
        state.albumPredicate = predicate
        return .none
    }
}
