//
//  AllPerformances.swift
//  AllPerformances
//
//  Created by Henry Cooper on 07/08/2022.
//

import SwiftUI
import GTCoreData
import GTFormatter
import Model
import Search
import TwoColumnTable
import ComposableArchitecture
import TableList

public struct AllPerformancesView {
    
    @ObservedObject var store: Store<TableListState, TableListAction>
    let formatter = GTFormatter.Formatter()
    
    @FetchRequest(entity: Performance.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
    public var fetched: FetchedResults<Performance>
    @State public var sortOrder: [KeyPathComparator<Performance>] = [
        .init(\.date, order: SortOrder.reverse),
        .init(\.venue, order: SortOrder.forward)
    ]
    
    public init(store: Store<TableListState, TableListAction>) {
        self.store = store
    }
    
    @State private var ids: Set<ObjectIdentifier> = []
    
    public var body: some View {
        
        Table(tableData, selection: $ids, sortOrder: $sortOrder) {
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
        .onAppear { ids = store.value.ids }
        .onChange(of: store.value.ids) { newValue in
            ids = newValue
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
