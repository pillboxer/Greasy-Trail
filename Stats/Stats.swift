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
            HStack {
                Spacer()
                Text("v.\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                    .italic()
            }
            Spacer()
            SearchFieldView(store: store.scope(state: { $0.search }, action: { StatsFeatureAction.search($0)}), font: .systemFont(ofSize: 28))
                .frame(width: 456)
            Spacer()
            HStack {
                StatInfoView(songsCount: songs.count,
                                 albumsCount: albums.count,
                                 performancesCount: performances.count,
                                 lbCount: lbCount,
                                 viewStore: viewStore)
                Spacer()
            }
        }
        .font(.caption)
        .padding()
    }
}

struct StatInfoView: View {
    
    let songsCount: Int
    let albumsCount: Int
    let performancesCount: Int
    let lbCount: Int
    
    @ObservedObject var viewStore: ViewStore<StatsViewState, StatsViewAction>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Songs: \(songsCount)")
            Text("Albums: \(albumsCount)")
            Text("Performances: \(performancesCount)")
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
    }
    
}
