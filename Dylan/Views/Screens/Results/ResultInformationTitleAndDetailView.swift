//
//  ResultInformationTitleAndDetailView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

/// Basic title and detail view
struct ResultsInformationTitleAndDetailView: View {

    let title: String
    let detail: String

    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
            Spacer()
            Text(detail)
        }
    }

}
