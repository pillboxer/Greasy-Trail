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
    
    let store: Store<AnyModel?, SearchAction>
    
    private let performances: [sPerformance]
    
    private var sorted: [sPerformance] {
        performances.sorted { $0.date ?? 0 < $1.date ?? 0 }
    }
    
    public init(performances: [sPerformance], store: Store<AnyModel?, SearchAction>) {
        self.performances = performances
        self.store = store
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
                        store.send(.makeSearch(.init(title: String(date), type: .performance)))
                    }
                }
                Divider()
                    .padding(.leading, 2)
            }
        }
    }
}
