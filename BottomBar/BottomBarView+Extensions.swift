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
        PlainOnTapButton(systemImage: "house") {
            viewStore.send(.reset, animation: .default)
        }
        .help("bottom_bar_tooltip_house")
    }
    
    var searchButton: some View {
        PlainOnTapButton(systemImage: "magnifyingglass") {
            viewStore.send(.toggleSearchField, animation: .default)
        }
        .help("bottom_bar_tooltip_search")
    }
    
    var randomButton: some View {
        PlainOnTapButton(systemImage: "dice") {
            viewStore.send(.makeRandomSearch)
        }
        .help("bottom_bar_tooltip_random")
    }
    
    var openAddButton: some View {
        PlainOnTapButton(systemImage: "plus.square") {
            viewStore.send(.selectSection(.add), animation: .default)
        }
        .help("bottom_bar_tooltip_new")
    }
    
    var closeAddButton: some View {
        PlainOnTapButton(systemImage: "minus.square") {
            viewStore.send(.reset, animation: .default)
            viewStore.send(.selectSection(.home(.songs)))
        }
    }
    
    @ViewBuilder
    var songButton: some View {
        switch viewStore.selectedSection {
        case .add:
            PlainOnTapButton(systemImage: DylanWork.songs.imageName) {
                viewStore.send(.reset, animation: .default)
                viewStore.send(.selectRecordToAdd(.songs), animation: .default)
            }
            .highlighting(viewStore.selectedRecordToAdd == .songs)
        case .home(let selectedRecord):
            PlainOnTapButton(systemImage: DylanWork.songs.imageName) {
                viewStore.send(.selectSection(.home(.songs)), animation: .default)
            }
            .highlighting(BottomBarSection.home(selectedRecord) == BottomBarSection.home(.songs))
        }
    }
    
    var albumButton: some View {
        PlainOnTapButton(systemImage: DylanWork.albums.imageName) {
            viewStore.send(.reset, animation: .default)
            viewStore.send(.selectRecordToAdd(.albums), animation: .default)
        }
        .highlighting(viewStore.selectedRecordToAdd == .albums)
    }
    
    @ViewBuilder
    var performanceButton: some View {
        switch viewStore.selectedSection {
        case .add:
            PlainOnTapButton(systemImage: DylanWork.performances.imageName) {
            viewStore.send(.reset, animation: .default)
            viewStore.send(.selectRecordToAdd(.performances), animation: .default)
        }
        .highlighting(viewStore.selectedRecordToAdd == .performances)
        case .home(let selectedRecord):
            PlainOnTapButton(systemImage: DylanWork.performances.imageName) {
                viewStore.send(.selectSection(.home(.performances)), animation: .default)
            }
            .highlighting(BottomBarSection.home(selectedRecord) == BottomBarSection.home(.performances))
        }
            
    }
    
    var uploadButton: some View {
        PlainOnTapButton(systemImage: "arrow.up.circle") {
            print("Must upload \(viewStore.model)")
        }
        .disabled(!(viewStore.model?.uploadAllowed ?? true))
    }
    
    var editButton: some View {
        PlainOnTapButton(systemImage: "pencil") {
            guard let id = viewStore.selectedObjectID else {
                return
            }
            viewStore.send(.selectSection(.add))
            viewStore.send(.search(id))
        }
    }
}
