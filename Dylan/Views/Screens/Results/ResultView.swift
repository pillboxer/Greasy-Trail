//
//  ResultView.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

/// Coordinates between different result views
struct ResultView: View {

    enum ResultViewType {
        case overview
        case albums([Album])
    }
    
    let model: SongDisplayModel
    @State private var currentViewType: ResultViewType = .overview
    
    var body: some View {
        
        switch currentViewType {
        case .overview:
            ResultOverviewView(model: model, currentViewType: $currentViewType)
        case .albums(let albums):
            ResultAlbumsTableView(albums: albums)
        }
    }
    
}
