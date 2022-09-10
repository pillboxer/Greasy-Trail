//
//  BottomBarView+Extensions.swift
//  BottomBar
//
//  Created by Henry Cooper on 30/08/2022.
//

import SwiftUI
import UI

extension BottomBarView {
    
    // TODO: help
    
    var homeButton: some View {
        OnTapButton(systemImage: "house") {
            viewStore.send(.reset, animation: .default)
        }
        .help("bottom_bar_tooltip_house")
    }
    
    var searchButton: some View {
        OnTapButton(systemImage: "magnifyingglass") {
            viewStore.send(.toggleSearchField, animation: .default)
        }
        .help("bottom_bar_tooltip_search")
    }
    
    var randomButton: some View {
        OnTapButton(systemImage: "dice") {
            viewStore.send(.makeRandomSearch)
        }
        .help("bottom_bar_tooltip_random")
    }
    
    var openAddButton: some View {
        OnTapButton(systemImage: "plus.square") {
            viewStore.send(.selectSection(.add), animation: .default)
        }
        .help("bottom_bar_tooltip_new")
    }
    
    var closeAddButton: some View {
        OnTapButton(systemImage: "minus.square") {
            viewStore.send(.reset, animation: .default)
            viewStore.send(.selectSection(.home))
        }
    }
    
    var songButton: some View {
        OnTapButton(systemImage: "music.note") {
            viewStore.send(.selectRecordToAdd(.song), animation: .default)
        }
        .highlighting(viewStore.selectedRecordToAdd == .song)
    }
    
    var albumButton: some View {
        OnTapButton(systemImage: "record.circle") {
            viewStore.send(.selectRecordToAdd(.album), animation: .default)
        }
        .highlighting(viewStore.selectedRecordToAdd == .album)
    }
    
    var performanceButton: some View {
        OnTapButton(systemImage: "music.mic.circle") {
            viewStore.send(.selectRecordToAdd(.performance), animation: .default)
        }
        .highlighting(viewStore.selectedRecordToAdd == .performance)
    }
    
    var uploadButton: some View {
        OnTapButton(systemImage: "arrow.up.circle") {
            print("Must upload \(viewStore.model)")
        }
        .disabled(!(viewStore.model?.uploadAllowed ?? true))
    }
    
    var editButton: some View {
        OnTapButton(systemImage: "pencil") {
            guard let id = viewStore.selectedObjectID else {
                return
            }
            viewStore.send(.selectSection(.add))
            viewStore.send(.search(id))
        }
    }
}

private extension View {
    
    func highlighting(_ shouldHighlight: Bool) -> some View {
        VStack {
            self
            if shouldHighlight {
                Divider()
                    .frame(maxWidth: 6)
                    .foregroundColor(.accentColor)
            }
        }
    }
}
