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
import BottomBar
import Add
import Core
import UI
import TopBar
import Model
import AllPerformances

struct ContentView: View {
    
    let store: Store<AppState, AppAction>
    @ObservedObject private var viewStore: ViewStore<ContentViewState, Never>
    @State private var selectedID: String?
    
    struct ContentViewState: Equatable {
        var selectedID: ObjectIdentifier?
        var model: AnyModel?
        var displayedView: DisplayedView
        var selectedPerformanceDecade: PerformanceDecade
        var mode: Mode?
        var showingCloudKitError: Bool
    }
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = ViewStore(store.actionless.scope(state: {
            ContentViewState(selectedID: $0.selectedID,
                             model: $0.search.model,
                             displayedView: $0.displayedView,
                             selectedPerformanceDecade: $0.selectedPerformanceDecade,
                             mode: $0.mode,
                             showingCloudKitError: $0.showingCloudKitError)}))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewStore.mode != nil {
                TopBarView(store: store.scope(state: {
                    $0.topBarState
                }, action: { .topBar($0) }))
                .padding(.horizontal)
                .transition(.move(edge: .bottom))
                Divider()
            }
            view(for: viewStore.displayedView)
            Spacer()
            BottomBarView(store: store.scope(state: { $0.bottomBarState },
                                             action: { .bottomBar($0) }))
        }
        .frame(width: 900, height: 600)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
    
    @ViewBuilder
    func view(for section: DisplayedView) -> some View {
        switch section {
        case .add:
            AddView(store: store.scope(state: { $0.addState },
                                       action: { .add($0) }))
        case .home:
            AllSongsView(store: store.scope(state: { $0.selectedID },
                                            action: { .search($0) }))
        case .result:
            ResultView(store: store.scope(state: { $0.search },
                                          action: { .search($0) }))
        case .songs:
            AllSongsView(store: store.scope(state: { $0.selectedID },
                                            action: { .search($0) }))
        case .albums:
            Text("Album")
        case .performances:
            AllPerformancesView(store: store.scope(state: { $0.allPerformancesState },
                                                   action: { .allPerformances($0)}),
                                predicate: viewStore.selectedPerformanceDecade.predicate)
        }
    }
}
