import GTCoreData
import SwiftUI
import Core
import UI
import ComposableArchitecture

public struct StatsState: Equatable {
    public var displayedView: DisplayedView
    public var isFetchingMissingLBCount: Bool
    public var missingLBNumbers: [Int]?
    
    public init(displayedView: DisplayedView,
                isFetchingMissingLBCount: Bool,
                missingLBNumbers: [Int]?) {
        self.displayedView = displayedView
        self.isFetchingMissingLBCount = isFetchingMissingLBCount
        self.missingLBNumbers = missingLBNumbers
    }
}

public enum StatsAction {
    case selectDisplayedView(DisplayedView)
    case fetchMissingLBNumbers
    case completeFetch([Int])
}

public let statsReducer = Reducer<StatsState, StatsAction, Void> { state, action, _ in
    switch action {
    case .selectDisplayedView(let displayedView):
        state.displayedView = displayedView
        return .none
    case .fetchMissingLBNumbers:
        state.isFetchingMissingLBCount = true
        return .future { promise in
            let context = PersistenceController.shared.newBackgroundContext()
            let request: NSFetchRequest<Performance> = Performance.fetchRequest()
            context.perform {
                do {
                    let objects = try context.fetch(request)
                    let allLBs = objects
                        .compactMap { $0.lbNumbers }
                        .flatMap { Set($0) }
                    let missingLBS = (1...15599).filter { !allLBs.contains($0) }
                    promise(.success(.completeFetch(missingLBS)))
                } catch let error {
                    fatalError()
                }
            }
        }
        .receive(on: DispatchQueue.main.eraseToAnyScheduler())
        .eraseToEffect()
    case .completeFetch(let lbNumbers):
        state.missingLBNumbers = lbNumbers
        state.isFetchingMissingLBCount = false
        return Effect(value: StatsAction.selectDisplayedView(.missingLBs))
    }
}

public struct StatsView: View {
    
    let store: Store<StatsState, StatsAction>
    
    public init(store: Store<StatsState, StatsAction>) {
        self.store = store
    }
    
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
        WithViewStore(store) { viewStore in
            VStack {
                Spacer()
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
                
            }
            .font(.caption)
            .padding()
        }
    }
}

public struct MissingLBsView: View {
    
    private let lbNumbers: [Int]
    
    public init(lbNumbers: [Int]) {
        self.lbNumbers = lbNumbers
    }
    
    public var body: some View {
        List(lbNumbers, id: \.self) { lb in
            OnTapButton(text: "LB-\(String(lb))") {
                NSWorkspace.shared.open(lb.lbURL())
            }
            .buttonStyle(.link)
        }
    }
    
}
