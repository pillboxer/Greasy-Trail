//
//  ListRowView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import AllPerformances
import AllSongs
import ComposableArchitecture
import GTCloudKit
import Search
import Sidebar
import SwiftUI
import UI

struct SidebarListRowView: View {
    
    let store: Store<AppState, AppAction>
    @ObservedObject private var viewStore: ViewStore<AppState>
    
    let displayType: SidebarDisplayType
    let isFetching: Bool
    var progress: Double?
    
    @State private var selection: String
    @Binding var selectedID: String?
    
    init(store: Store<AppState, AppAction>,
         displayType: SidebarDisplayType,
         isFetching: Bool, progress: Double?,
         selectedID: Binding<String?>) {
        self.store = store
        self.displayType = displayType
        self.isFetching = isFetching
        self.progress = progress
        self.selection = displayType.rawValue
        self.viewStore = store.view(id: "Sidebar")
        _selectedID = selectedID
    }
    
    var body: some View {
        NavigationLink(destination: destinationFor(selection),
                       tag: displayType.rawValue,
                       selection: $selectedID) {
            HStack {
                ListRowView(headline: displayType.rawValue)
                Spacer()
                if isFetching {
                    VStack {
                        ProgressView("", value: progress, total: 1)
                            .frame(maxWidth: 50)
                        Spacer()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func destinationFor(_ selection: String) -> some View {
        if let section = SidebarDisplayType(rawValue: selection) {
            switch section {
            case .songs:
                AllSongsView(store: store.scope(value: {
                    SearchState(model: $0.model,
                                failedSearch: $0.failedSearch,
                                currentSearch: $0.currentSearch,
                                ids: $0.selectedModel,
                                isSearching: $0.isSearching)
                }, action: { action in
                    return .search(action)
                }))
            case .albums:
                AllAlbumsView()
            default:
                AllPerformancesView(store: store.scope(value: {
                    SearchState(model: $0.model,
                                failedSearch: $0.failedSearch,
                                currentSearch: $0.currentSearch,
                                ids: $0.selectedModel,
                                isSearching: $0.isSearching)
                }, action: { action in
                    return .search(action)
                }), predicate: section.predicate)
            }
        } else {
            fatalError()
        }
    }
}
