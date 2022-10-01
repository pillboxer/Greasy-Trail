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
                    .font(.system(size: 24, weight: .ultraLight, design: .monospaced))
            }
            Text("Greasy Trail")
                .font(.custom("RockSalt-Regular", size: 36))
            Spacer()
            SearchFieldView(store: store.scope(
                state: { $0.search },
                action: { StatsFeatureAction.search($0) }
            ), font: .systemFont(ofSize: 28))
            .frame(width: 456)
            Text("Try \"Like a Rolling Stone\" or \"April 15 2007\"")
            Spacer()
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
                Text("Missing LB Numbers: \(15630 - lbCount)")
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
