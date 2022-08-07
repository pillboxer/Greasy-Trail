//
//  AllPerformances.swift
//  AllPerformances
//
//  Created by Henry Cooper on 07/08/2022.
//

import SwiftUI
import GTCoreData
import GTFormatter
import TableSelection
import Search
import TwoColumnTable
import ComposableArchitecture

public enum AllPerformancesViewAction {
    case tableSelect(TableSelectionAction)
    case search(SearchAction)
}

public struct AllPerformancesView {
    
    @ObservedObject var store: Store<Set<ObjectIdentifier>, AllPerformancesViewAction>
    let formatter = GTFormatter.Formatter()
    
    @FetchRequest(entity: Performance.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
    public var fetched: FetchedResults<Performance>
    @State public var sortOrder: [KeyPathComparator<Performance>] = [
        .init(\.date, order: SortOrder.reverse),
        .init(\.venue, order: SortOrder.forward)
    ]
    
    public init(store: Store<Set<ObjectIdentifier>, AllPerformancesViewAction>) {
        self.store = store
    }
    
    public var body: some View {
        
        Table(tableData, selection: $store.value, sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_performances_0"), value: \.venue!) { performance in
                let venue = performance.venue!
                let date = String(performance.date)

                Text(venue)
                    .gesture(doubleTap(on: date, id: performance.id))
                    .simultaneousGesture(singleTap(id: performance.id))
            }
            TableColumn(LocalizedStringKey("table_column_title_performances_1"), value: \.date) { performance in
                let date = String(performance.date)
                
                Text(formatter.dateString(of: performance.date))
                    .gesture(doubleTap(on: date, id: performance.id))
                    .simultaneousGesture(singleTap(id: performance.id))
            }
        }
    }
}

extension AllPerformancesView: TwoColumnTableViewType {
    
    public func doubleTap(on string: String, id: Performance.ID) -> _EndedGesture<TapGesture> {
        TapGesture(count: 2).onEnded { _ in
            store.send(.search(.makeSearch(.init(title: string, type: .performance))))
        }
    }
    
    public func singleTap(id: Performance.ID) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                store.send(.tableSelect(.select(identifier: id)))
            }
    }
}
