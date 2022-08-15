//
//  ListRowView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import SwiftUI
import ComposableArchitecture
import TableSelection
import AllPerformances
import UI
import TableList
import GTCloudKit
import AllSongs
import Sidebar

struct SidebarListRowView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    let displayType: SidebarDisplayType
    let isFetching: Bool
    var progress: Double?
    
    @State private var selection: String
    @State private var expandedListShowing = false
    @Binding var selectedID: String?
    
    init(displayType: SidebarDisplayType,
         isFetching: Bool, progress: Double?,
         selectedID: Binding<String?>) {
        self.displayType = displayType
        self.isFetching = isFetching
        self.progress = progress
        self.selection = displayType.rawValue
        _selectedID = selectedID
    }
        
    var body: some View {
        NavigationLink(destination: destinationFor(selection).environmentObject(store),
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
                AllSongsView(store: store.view(value: {
                    TableListState(ids: $0.selection, model: $0.model, failedSearch: $0.failedSearch)
                }, action: { action in
                    return .tableList(action)
                }))
            case .albums:
                AllAlbumsView()
            default:
                AllPerformancesView(store: store.view(value: {
                    TableListState(ids: $0.selection, model: $0.model, failedSearch: $0.failedSearch)
                }, action: { action in
                    return .tableList(action)
                }), predicate: section.predicate)
            }
        } else {
            fatalError()
        }
    }
}
