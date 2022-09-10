//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI
import ComposableArchitecture
import GTCoreData
import Result
import Search
import GTCloudKit
import AllSongs
import Sidebar
import BottomBar
import Add
import Model
import AllPerformances

struct ContentView: View {
    
    let store: Store<AppState, AppAction>
    @ObservedObject private var viewStore: ViewStore<ContentViewState, Never>
    @State private var selectedID: String?
    
    struct ContentViewState: Equatable {
        var selectedID: ObjectIdentifier?
        var model: AnyModel?
        var selectedSection: BottomBarSection
        var selectedPerformanceDecade: PerformanceDecade
        var mode: Mode
    }
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = ViewStore(store.actionless.scope(state: {
            ContentViewState(selectedID: $0.selectedID,
                             model: $0.search.model,
                             selectedSection: $0.selectedSection,
                             selectedPerformanceDecade: $0.selectedPerformanceDecade,
                             mode: $0.mode)}))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if case let Mode.downloading(progress, type) = viewStore.mode {
                DownloadingView(store: store.actionless.scope { _ in
                    DownloadingView.DownloadingViewState(type: type.bridged, progress: progress)
                })
                .padding(.horizontal)
                .transition(.move(edge: .bottom))
                Divider()
            }
            switch viewStore.selectedSection {
            case .add:
                AddView(store: store.scope(state: { $0.addState },
                                           action: { .add($0) }))
            case .home(let record):
                if viewStore.model != nil {
                    ResultView(store: store.scope(state: { $0.search },
                                                  action: { .search($0) }))
                } else {
                    switch record {
                    case .songs:
                        AllSongsView(store: store.scope(state: { $0.selectedID },
                                                        action: { action in
                            return .search(action)
                        }))
                    case .albums:
                        Text("Album")
                    case .performances:
                        AllPerformancesView(store: store.scope(state: { $0.allPerformancesState },
                                                               action: { .allPerformances($0)}),
                                            predicate: viewStore.selectedPerformanceDecade.predicate)
                    }
                }
            }
            BottomBarView(store: store.scope(state: { $0.bottomBarState },
                                             action: { .bottomBar($0) }))
        }
        .frame(width: 900, height: 600)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        
    }
}

private extension DylanRecordType {
    var sidebarDisplayType: SidebarDisplayType? {
        switch self {
        case .song:
            return .songs
        case .album:
            return .albums
        case .performance:
            return .performances
        case .appMetadata:
            return nil
        }
    }
}

struct DownloadingView: View {
    
    struct DownloadingViewState: Equatable {
        let type: DylanWork
        let progress: Double
    }
    
    let store: Store<DownloadingViewState, Never>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Image(systemName: viewStore.type.imageName)
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: 12, height: 12)
                    Text("Fetching latest \(viewStore.type.rawValue.capitalized)")
                        .font(.caption)
                    Spacer()
                    ProgressView(value: viewStore.progress)
                        .frame(width: 256)
                    Text(String(Int(viewStore.progress * 100)) + "%")
                        .font(.caption)
                        .frame(width: 36)
                }
            }
            .frame(maxHeight: 36)
        }
    }
}

extension DylanRecordType {
    
    var bridged: DylanWork {
        switch self {
        case .song:
            return .songs
        case .performance:
            return .performances
        case .album:
            return .albums
        default:
            fatalError()
        }
    }
    
}
