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

struct SidebarListRowView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    let recordType: DylanRecordType
    let isFetching: Bool
    var progress: Double?
    
    @State private var selection: String
    @Binding var selectedID: String?
    
    init(recordType: DylanRecordType,
         isFetching: Bool, progress: Double?,
         selectedID: Binding<String?>,
         onTap: @escaping () -> Void) {
        self.recordType = recordType
        self.isFetching = isFetching
        self.progress = progress
        self.selection = recordType.rawValue
        self.onTap = onTap
        _selectedID = selectedID
    }
    
    let onTap: () -> Void
    
    var body: some View {
        NavigationLink(destination: destinationFor(selection).environmentObject(store),
                       tag: recordType.rawValue,
                       selection: $selectedID) {
            HStack {
                Text(selection.capitalized + "s")
                    .font(.headline)
                Spacer()
                if isFetching {
                    VStack {
                        ProgressView("", value: progress, total: 1)
                            .frame(maxWidth: 50)
                        Spacer()
                    }
                } else {
                    OnTapButton(systemImage: "cross.fill") {
                        onTap()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    func destinationFor(_ selection: String) -> some View {
        if let section = DylanRecordType(rawValue: selection) {
            switch section {
            case .song:
                AllSongsView(store: store.view(value: {
                    TableListState(ids: $0.selection, model: $0.model, failedSearch: $0.failedSearch)
                }, action: { action in
                    return .tableList(action)
                }))
            case .album:
                AllAlbumsView()
            case .performance:
                AllPerformancesView(store: store.view(value: {
                    TableListState(ids: $0.selection, model: $0.model, failedSearch: $0.failedSearch)
                }, action: { action in
                    return .tableList(action)
                }))
            default:
                fatalError("Should not reach here")
            }
        } else {
            fatalError()
        }
    }
}
