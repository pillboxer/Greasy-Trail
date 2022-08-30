//
//  PerformancesListView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 15/07/2022.
//

import SwiftUI
import GTFormatter
import Search
import Model
import ComposableArchitecture
import UI

public struct PerformancesListView: View {
    
    fileprivate enum PerformancesListAction {
        case search(Search)
    }
    
    fileprivate struct PerformancesListState: Equatable {}
    
    let store: Store<AnyModel?, SearchAction>
    @ObservedObject private var viewStore: ViewStore<PerformancesListState, PerformancesListAction>

    private let performances: [sPerformance]
 
    public init(performances: [sPerformance], store: Store<AnyModel?, SearchAction>) {
        self.performances = performances
        self.store = store
        self.viewStore = store.scope(value: { _ in PerformancesListState() },
                                     action: SearchAction.init).view
    }
    
    private let formatter = GTFormatter.Formatter()
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("performances_list_title").font(.title)
                .padding(.bottom)
            
            List(performances, id: \.self) { performance in
                let title = performance.venue
                HStack(alignment: .top) {
                    ListRowView(headline: title,
                                subheadline: formatter.dateString(of: performance.date)) {
                        guard let date = performance.date else { return }
                        viewStore.send(.search(.init(title: String(date),
                                                     type: .performance)))
                    }
                }
                Divider()
                    .padding(.leading, 2)
            }
        }
    }
}

fileprivate extension SearchAction {
    
    init(action: PerformancesListView.PerformancesListAction) {
        switch action {
        case .search(let search):
            self = .makeSearch(search)
        }
    }
}
