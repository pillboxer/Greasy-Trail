import SwiftUI
import UI
import Core

extension BottomBarView {
    
    var homeButton: some View {
        PlainOnTapButton(systemImage: "house") {
            logger.log("Tapped home")
            viewStore.send(.reset(.home), animation: .default)
            viewStore.send(.resetFavoriteResult)
        }
        .help("bottom_bar_tooltip_house")
    }
    
    var searchButton: some View {
        PlainOnTapButton(systemImage: "magnifyingglass") {
            logger.log("Tapped search")
            viewStore.send(.toggleSearchField, animation: .default)
        }
        .help("bottom_bar_tooltip_search")
    }
    
    var randomButton: some View {
        PlainOnTapButton(systemImage: "dice") {
            logger.log("Tapped random")
            viewStore.send(.makeRandomSearch)
            viewStore.send(.resetFavoriteResult)
        }
        .help("bottom_bar_tooltip_random")
    }
    
    var openAddButton: some View {
        PlainOnTapButton(systemImage: "plus.square") {
            logger.log("Tapped open add")
            viewStore.send(.selectView(.add(.songs)), animation: .default)
        }
        .help("bottom_bar_tooltip_new")
    }
    
    var closeAddButton: some View {
        PlainOnTapButton(systemImage: "minus.square") {
            logger.log("Tapped close add")
            viewStore.send(.reset(.songs), animation: .default)
        }
    }
    
    var refreshButton: some View {
        PlainOnTapButton(systemImage: "arrow.clockwise.circle") {
            viewStore.send(.refresh)
        }
        .disabled(viewStore.isDownloading)
    }
    
    @ViewBuilder
    var songButton: some View {
        Group {
            switch viewStore.displayedView {
            case .add:
                PlainOnTapButton(systemImage: DylanWork.songs.imageName) {
                    logger.log("Tapped song (add)")
                    viewStore.send(.reset(.add(.songs)), animation: .default)
                }
                .highlighting(DisplayedView.add(.songs) ==  viewStore.displayedView)
            default:
                PlainOnTapButton(systemImage: DylanWork.songs.imageName) {
                    logger.log("Tapped song (home)")
                    viewStore.send(.selectView(.songs), animation: .default)
                }
                .highlighting(DisplayedView.songs == viewStore.displayedView)
            }
        }
        .help("bottom_bar_tooltip_songs")
    }
    
    @ViewBuilder
    var albumButton: some View {
        Group {
            switch viewStore.displayedView {
            case .add:
                PlainOnTapButton(systemImage: DylanWork.albums.imageName) {
                    logger.log("Tapped album (add)")
                    viewStore.send(.reset(.add(.albums)), animation: .default)
                }
                .highlighting(DisplayedView.add(.albums) ==  viewStore.displayedView)
            default:
                PlainOnTapButton(systemImage: DylanWork.albums.imageName) {
                    logger.log("Tapped album (home)")
                    viewStore.send(.selectView(.albums), animation: .default)
                }
                .highlighting(DisplayedView.albums == viewStore.displayedView)
            }
        }
        .help("bottom_bar_tooltip_albums")
    }
    
    @ViewBuilder
    var performanceButton: some View {
        Group {
            switch viewStore.displayedView {
            case .add:
                PlainOnTapButton(systemImage: DylanWork.performances.imageName) {
                    logger.log("Tapped performance (add)")
                    viewStore.send(.reset(.add(.performances)), animation: .default)
                }
                .highlighting(DisplayedView.add(.performances) ==  viewStore.displayedView)
            default:
                PlainOnTapButton(systemImage: DylanWork.performances.imageName) {
                    logger.log("Tapped performance (home)")
                    viewStore.send(.selectView(.performances), animation: .default)
                }
                .highlighting(DisplayedView.performances == viewStore.displayedView)
            }
        }
        .help("bottom_bar_tooltip_performances")
    }
    
    @ViewBuilder
    var favoriteButton: some View {
        if let success = viewStore.displayedFavorite {
            PlainOnTapButton(systemImage: success ? "star.fill" : "star") {
                logger.log("Tapped favorite")
                viewStore.send(.toggleFavorite)
            }
        } else if let model = viewStore.model {
            PlainOnTapButton(systemImage: model.isFavorite ? "star.fill" : "star") {
                logger.log("Tapped favorite")
                viewStore.send(.toggleFavorite)
            }
        } else {
            EmptyView()
        }
    }
    
    var uploadButton: some View {
        PlainOnTapButton(systemImage: "arrow.up.circle") {
            guard let model = viewStore.model else {
                return
            }
            var displayedView: DisplayedView = .home
            switch viewStore.displayedView {
            case .add(let work):
                switch work {
                case .songs:
                    displayedView = .songs
                case .albums:
                    displayedView = .albums
                case .performances:
                    displayedView = .performances
                }
            default:
                break
            }
            logger.log("Tapped upload")
            viewStore.send(.upload(model.value))
            viewStore.send(.reset(displayedView))
        }
        .disabled(!(viewStore.model?.uploadAllowed ?? false))
    }
    
    var editButton: some View {
        PlainOnTapButton(systemImage: "pencil") {
            guard let id = viewStore.selectedObjectID else {
                return
            }
            logger.log("Tapped edit")
            viewStore.send(.selectView(.add(.songs)))
            viewStore.send(.search(id))
        }
    }
}
