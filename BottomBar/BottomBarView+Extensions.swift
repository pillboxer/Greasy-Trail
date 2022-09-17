import SwiftUI
import UI
import Core

extension BottomBarView {
    
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
            viewStore.send(.selectView(.add(.songs)), animation: .default)
        }
        .help("bottom_bar_tooltip_new")
    }
    
    var closeAddButton: some View {
        PlainOnTapButton(systemImage: "minus.square") {
            viewStore.send(.reset, animation: .default)
        }
    }
    
    @ViewBuilder
    var songButton: some View {
        switch viewStore.displayedView {
        case .add:
            PlainOnTapButton(systemImage: DylanWork.songs.imageName) {
                viewStore.send(.reset, animation: .default)
                viewStore.send(.selectView(.add(.songs)), animation: .default)
            }
            .highlighting(DisplayedView.add(.songs) ==  viewStore.displayedView)
        default:
            PlainOnTapButton(systemImage: DylanWork.songs.imageName) {
                viewStore.send(.selectView(.songs), animation: .default)
            }
            .highlighting(DisplayedView.songs == viewStore.displayedView)
        }
    }
    
    @ViewBuilder
    var albumButton: some View {
        switch viewStore.displayedView {
        case .add:
            PlainOnTapButton(systemImage: DylanWork.albums.imageName) {
                viewStore.send(.reset, animation: .default)
                viewStore.send(.selectView(.add(.albums)), animation: .default)
            }
            .highlighting(DisplayedView.add(.albums) ==  viewStore.displayedView)
        default:
            PlainOnTapButton(systemImage: DylanWork.albums.imageName) {
                viewStore.send(.selectView(.albums), animation: .default)
            }
            .highlighting(DisplayedView.albums == viewStore.displayedView)
        }
    }
    
    @ViewBuilder
    var performanceButton: some View {
        switch viewStore.displayedView {
        case .add:
            PlainOnTapButton(systemImage: DylanWork.performances.imageName) {
                viewStore.send(.reset, animation: .default)
                viewStore.send(.selectView(.add(.performances)), animation: .default)
            }
            .highlighting(DisplayedView.add(.performances) ==  viewStore.displayedView)
        default:
            PlainOnTapButton(systemImage: DylanWork.performances.imageName) {
                viewStore.send(.selectView(.performances), animation: .default)
            }
            .highlighting(DisplayedView.performances == viewStore.displayedView)
        }
        
    }
    
    var uploadButton: some View {
        PlainOnTapButton(systemImage: "arrow.up.circle") {
            guard let model = viewStore.model else {
                return
            }
            viewStore.send(.upload(model.value))
            viewStore.send(.reset)
        }
        .disabled(!(viewStore.model?.uploadAllowed ?? true))
    }
    
    var editButton: some View {
        PlainOnTapButton(systemImage: "pencil") {
            guard let id = viewStore.selectedObjectID else {
                return
            }
            viewStore.send(.selectView(.add(.songs)))
            viewStore.send(.search(id))
        }
    }
}
