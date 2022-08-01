//
//  PerformancesListView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 15/07/2022.
//

import SwiftUI

struct PerformancesListView: View {

    let performances: [sPerformance]

    var sorted: [sPerformance] {
        performances.sorted { $0.date < $1.date }
    }

    let onTap: (String) -> Void
    private let formatter = Formatter()

    var body: some View {
        VStack(alignment: .leading) {
            Text("performances_list_title").font(.title)
                .padding(.bottom)
             
                List(performances, id: \.self) { performance in
                    let title = performance.venue
                    HStack(alignment: .top) {
                        ListRowView(headline: title, subHeadline: formatter.dateString(of: performance.date)) {
                            onTap(String(performance.date))
                        }
                    }
                    .padding(2)
                }
        }
    }
}
