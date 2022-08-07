//
//  PerformancesListView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 15/07/2022.
//

import SwiftUI
import GTFormatter
import Model

struct PerformancesListView: View {

    let performances: [sPerformance]

    var sorted: [sPerformance] {
        performances.sorted { $0.date ?? 0 < $1.date ?? 0 }
    }

    let onTap: (String) -> Void
    private let formatter = GTFormatter.Formatter()

    var body: some View {
        VStack(alignment: .leading) {
            Text("performances_list_title").font(.title)
                .padding(.bottom)
             
                List(performances, id: \.self) { performance in
                    let title = performance.venue
                    HStack(alignment: .top) {
                        ListRowView(headline: title, subHeadline: formatter.dateString(of: performance.date)) {
                            guard let date = performance.date else {
                                return
                            }
                            onTap(String(date))
                        }
                    }
                    .padding(2)
                }
        }
    }
}
