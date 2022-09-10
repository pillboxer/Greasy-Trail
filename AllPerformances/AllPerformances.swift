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
        case selectID(objectIdentifier: ObjectIdentifier?)
        case select(objectIdentifier: ObjectIdentifier?, id: NSManagedObjectID?)
    }
    
    private struct AllPerformancesState: Equatable {
        var selectedID: ObjectIdentifier?
    }
    
    let store: Store<SearchState, SearchAction>
    @ObservedObject private var viewStore: ViewStore<AllPerformancesState, AllPerformancesAction>
    
    let formatter = GTFormatter.Formatter()
    let predicate: NSPredicate
    @FetchRequest public var fetched: FetchedResults<Performance>
    @State public var sortOrder: [KeyPathComparator<Performance>] = [
        .init(\.date, order: SortOrder.reverse),
        .init(\.venue, order: SortOrder.forward)
    ]
    
    private func toggleBinding(on performance: Performance) -> Binding<Bool> {
        let ids = idsOnToggle(on: performance)
        return viewStore.binding(get: { $0.selectedID == performance.id },
                                 send: .select(objectIdentifier: ids.0,
                                               id: ids.1))
    }
    
    public init(store: Store<SearchState, SearchAction>,
                predicate: NSPredicate = NSPredicate(value: true)) {
        self.store = store
        self.predicate = predicate
        self.viewStore = ViewStore(store.scope(state: { AllPerformancesState(selectedID: $0.selectedID) },
                                               action: SearchAction.init))
        _fetched = FetchRequest<Performance>(entity: Performance.entity(),
                                             sortDescriptors: [NSSortDescriptor(key: "date",
                                                                                ascending: false)],
                                             predicate: predicate)
    }
    
    public var body: some View {
        return Table(tableData, sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_performances_0"),
                        value: \.venue!) { performance in
                let venue = performance.venue!
                Toggle(isOn: toggleBinding(on: performance)) {
                    Text(venue)
                        .padding(.leading, 4)
                }
                .padding(.top, 4)
                Spacer()
                    .gesture(doubleTap(objectID: performance.objectID))
                
            }
            TableColumn(LocalizedStringKey("table_column_title_performances_1"),
                        value: \.date) { performance in
                HStack {
                    Text(formatter.dateString(of: performance.date))
                    Spacer()
                }
                .contentShape(Rectangle())
                .gesture(doubleTap(objectID: performance.objectID))
            }
        }
    }
}

extension AllPerformancesView: TwoColumnTableViewType {
    
    public func doubleTap(objectID: NSManagedObjectID) -> _EndedGesture<TapGesture> {
        TapGesture(count: 2).onEnded { _ in
            viewStore.send(.search(.init(id: objectID)))
        }
    }
    
}

private extension AllPerformancesView {
    
    func idsOnToggle(on performance: Performance) -> (objectIdentifier: ObjectIdentifier?,
                                                      objectID: NSManagedObjectID?) {
        if viewStore.selectedID == performance.id {
            return (nil, nil)
        }
        return (performance.id, performance.objectID)
    }
    
}

private extension SearchAction {
    
    init(action: AllPerformancesView.AllPerformancesAction) {
        switch action {
        case .search(let search):
            self = .makeSearch(search)
        case .selectID(let objectIdentifier):
            self = .selectID(objectIdentifier: objectIdentifier)
        case .select(objectIdentifier: let objectIdentifier, id: let id):
            self = .select(objectIdentifier: objectIdentifier, objectID: id)
        }
    }
}
