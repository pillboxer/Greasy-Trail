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

public struct AllPerformancesView {
    
    fileprivate enum AllPerformancesAction {
        case search(Search)
        case select(ObjectIdentifier)
    }
    
    private struct AllPerformancesState: Equatable {
        var ids: Set<ObjectIdentifier>
    }
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<Set<ObjectIdentifier>, AllPerformancesAction>
    
    let formatter = GTFormatter.Formatter()
    let predicate: NSPredicate
    @FetchRequest public var fetched: FetchedResults<Performance>
    @State public var sortOrder: [KeyPathComparator<Performance>] = [
        .init(\.date, order: SortOrder.reverse),
        .init(\.venue, order: SortOrder.forward)
    ]
    
    public init(store: Store<SearchState, SearchAction>,
                predicate: NSPredicate = NSPredicate(value: true)) {
        self.store = store
        self.predicate = predicate
        self.viewStore = store.scope(value: { $0.ids }, action: SearchAction.init).view
        _fetched = FetchRequest<Performance>(entity: Performance.entity(),
                                            sortDescriptors: [NSSortDescriptor(key: "date",
                                                                               ascending: false)],
                                             predicate: predicate)
    }
        
    public var body: some View {
        Table(tableData, selection: .constant(viewStore.value), sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_performances_0"),
                        value: \.venue!) { performance in
                let venue = performance.venue!
                let date = String(performance.date)
                Text(venue)
                    .gesture(doubleTap(on: date, id: performance.id))
                    .simultaneousGesture(singleTap(id: performance.id))
            }
            TableColumn(LocalizedStringKey("table_column_title_performances_1"),
                        value: \.date) { performance in
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
            viewStore.send(.search(.init(title: string, type: .performance)))
        }
    }
    
    public func singleTap(id: Performance.ID) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                viewStore.send(.select(id))
            }
    }
}

private extension SearchAction {
    
    init(action: AllPerformancesView.AllPerformancesAction) {
        switch action {
        case .search(let search):
            self = .makeSearch(search)
        case .select(let id):
            self = .select(identifier: id)
        }
    }
}

