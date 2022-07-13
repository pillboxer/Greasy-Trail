//
//  ListRowView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 13/07/2022.
//

import SwiftUI

struct ListRowView: View {
    
    let headline: String
    var subHeadline: String?
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(headline).font(.headline)
                Spacer()
                OnTapButton(systemImage: "chevron.forward.square.fill") {
                    onTap()
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
            }
            if let subHeadline = subHeadline {
                Text(subHeadline).font(.subheadline)
            }
        }
    }
}
