import SwiftUI
import GTFormatter
import Search
import UI
import os
import GTCoreData
import TwoColumnTable
import ComposableArchitecture

let logger = Logger(subsystem: .subsystem, category: "All Performances")

public struct AllPerformancesView {
    
    let store: Store<AllPerformancesState, AllPerformancesFeatureAction>
    let formatter = GTFormatter.Formatter()
    let predicate: NSPredicate
    @ObservedObject private var viewStore: ViewStore<AllPerformancesViewState, AllPerformancesViewAction>
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
    
    public init(store: Store<AllPerformancesState, AllPerformancesFeatureAction>,
                predicate: NSPredicate = NSPredicate(value: true)) {
        self.store = store
        self.predicate = predicate
        self.viewStore = ViewStore(store.scope(state: {
            AllPerformancesViewState(selectedID: $0.search.selectedID,
                                     selectedDecade: $0.selectedPerformancePredicate) },
                                               action: AllPerformancesFeatureAction.init))
        _fetched = FetchRequest<Performance>(entity: Performance.entity(),
                                             sortDescriptors: [NSSortDescriptor(key: "date",
                                                                                ascending: false)],
                                             predicate: predicate)
    }
    
    public var body: some View {
        VStack {
            Text("performances_list_title")
                .underline()
                .font(.headline)
                .padding(.top)
            HStack {
                ForEach(PerformancePredicate.allCases, id: \.rawValue) { decade in
                    PlainOnTapButton(text: decade.rawValue) {
                        let decade = PerformancePredicate(rawValue: decade.rawValue)!
                        viewStore.send(.selectPerformancePredicate(decade))
                    }
                    .font(.caption.weight(decade == viewStore.state.selectedDecade ? .bold : .regular))
                }
            }
            .frame(height: 32)
            Table(tableData, sortOrder: $sortOrder) {
                TableColumn(LocalizedStringKey("table_column_title_performances_0"),
                            value: \.venue!) { performance in
                    let venue = performance.venue!
                    Toggle(isOn: toggleBinding(on: performance)) {
                        Text(venue)
                            .padding(.leading, 4)
                    }
                    .padding(.top, 4)
                    .toggleStyle(CheckboxToggleStyle())
                }
                TableColumn(LocalizedStringKey("table_column_title_performances_1"),
                            value: \.date) { performance in
                    HStack {
                        Text(formatter.dateString(of: performance.date))
                        Spacer()
                        PlainOnTapButton(systemImage: "chevron.right.circle") {
                            viewStore.send(.search(.init(id: performance.objectID)))
                        }
                    }
                }
                TableColumn(LocalizedStringKey("table_column_title_performances_2")) { performance in
                    Text(String(performance.lbNumbers?.count ?? 0))
                }
                .width(56)
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
