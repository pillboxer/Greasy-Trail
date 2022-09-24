import ComposableArchitecture
import Search

public let allSongsFeatureReducer: Reducer<AllSongsState,
                                           AllSongsFeatureAction,
                                           SearchEnvironment> =
Reducer.combine(
    searchReducer.pullback(
        state: \.search,
        action: /AllSongsFeatureAction.search,
        environment: { $0 }),
    allSongsReducer.pullback(
        state: \.self,
        action: /AllSongsFeatureAction.allSongs,
        environment: { _ in () }))

let allSongsReducer = Reducer<AllSongsState, AllSongsAction, Void> { state, action, _ in
    switch action {
    case .selectSongPredicate(let predicate):
        state.selectedSongPredicate = predicate
        return .none
    }
}
