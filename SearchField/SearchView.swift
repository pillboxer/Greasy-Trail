import SwiftUI
import UI
import Search
import ComposableArchitecture

public struct SearchView: View {
    
    private struct SearchViewState: Equatable {    }
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<Void, SearchAction>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        self.viewStore = ViewStore(store.stateless.scope(state: { _ in ()},
                                                         action: { $0 }))
    }

    public var body: some View {
        SearchFieldView(store: store)
    }

}
