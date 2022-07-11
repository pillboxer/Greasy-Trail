//
//  RecentPerformanceView(FIX).swift
//  Dylan
//
//  Created by Henry Cooper on 11/07/2022.
//

import SwiftUI
struct RecentPerformanceRow: View {
    
    let venue: String
    let date: Double
    @Binding var nextSearch: Search?
    private let formatter = Formatter()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(formatter.dateString(of: date)).font(.headline)
                Spacer()
                OnTapButton(systemImage: "chevron.forward.square.fill") {

                    withAnimation {
                        nextSearch = (String(date), .performance)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            Text(venue).font(.subheadline)
        }

    }
    
}

struct RecentAlbumRow: View {
    
    let title: String
    let date: Double
    @Binding var nextSearch: Search?
    private let formatter = Formatter()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                OnTapButton(systemImage: "chevron.forward.square.fill") {
                    withAnimation {
                        nextSearch = (String(title), .album)

                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            Text(formatter.dateString(of: date)).font(.subheadline)
        }

    }
    
}
