import GTCoreData
import SwiftUI
import UI
import Search
import SearchField
import ComposableArchitecture

public struct StatsView: View {
    
    let store: Store<StatsState, StatsFeatureAction>
    
    public init(store: Store<StatsState, StatsFeatureAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: StatsViewState.init, action: StatsFeatureAction.init))
    }
    
    @ObservedObject private var viewStore: ViewStore<StatsViewState, StatsViewAction>
    
    @FetchRequest(entity: Song.entity(), sortDescriptors: [], predicate: NSPredicate(format: "title != %@", "BREAK"))
    private var songs: FetchedResults<Song>
    
    @FetchRequest(entity: Album.entity(), sortDescriptors: [])
    private var albums: FetchedResults<Album>
    
    @FetchRequest(entity: Performance.entity(), sortDescriptors: [])
    private var performances: FetchedResults<Performance>
    
    private var lbCount: Int {
        performances
        .compactMap { $0.lbNumbers }
        .flatMap { Set($0) }
        .count
    }
    
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                SearchView(store: store.scope(state: { $0.search }, action: { StatsFeatureAction.search($0)}))
                Spacer()
            }
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Songs: \(songs.count)")
                    Text("Albums: \(albums.count)")
                    Text("Performances: \(performances.count)")
                    Text("LB Count: \(lbCount)")
                    HStack {
                        Text("Missing LB Numbers: \(15500 - lbCount)")
                        if viewStore.state.isFetchingMissingLBCount {
                            ProgressView()
                                .scaleEffect(0.4)
                        } else {
                            PlainOnTapButton(systemImage: "arrow.right.circle") {
                                viewStore.send(.fetchMissingLBNumbers)
                            }
                        }
                    }
                }
                Spacer()
            }
            .font(.caption)
            .padding()
        }
    }
}
