//
//  AllPerformancesView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import SwiftUI

struct AllPerformancesView {
    
    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    @State var selection: Set<Performance.ID> = []
    @FetchRequest(entity: Performance.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
    var fetched: FetchedResults<Performance>
    private let formatter = Formatter()
    @State var sortOrder: [KeyPathComparator<Performance>] = [
        .init(\.date, order: SortOrder.reverse),
        .init(\.venue, order: SortOrder.forward)
    ]
    
    var body: some View {
        
        Table(tableData, selection: $selection, sortOrder: $sortOrder) {
            TableColumn(LocalizedStringKey("table_column_title_performances_0"), value: \.venue!) { performance in
                let venue = performance.venue!
                let date = String(performance.date)
                
                PopoverRowView(headline: venue, onTap: {
                    searchViewModel.search(.init(title: date, type: .performance))
                }, popoverContent: {
                    LBAddingView(editorViewModel:
                                    LBsEditorViewModel(sPerformance: sPerformance(uuid: performance.uuid!,
                                                      venue: performance.venue!,
                                                      songs: [],
                                                      date: performance.date,
                                                      lbNumbers: performance.lbNumbers)))
                    .frame(width: 300, height: 300)
                })
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
    
    func doubleTap(on string: String, id: Performance.ID) -> _EndedGesture<TapGesture> {
        TapGesture(count: 2).onEnded { _ in
            selection.removeAll()
            searchViewModel.search(.init(title: string, type: .performance))
            selection.insert(id)
        }
    }
    
    func singleTap(id: Performance.ID) -> _EndedGesture<TapGesture> {
        TapGesture()
            .onEnded {
                selection.removeAll()
                selection.insert(id)
            }
    }
}
