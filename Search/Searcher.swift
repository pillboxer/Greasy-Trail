import GTFormatter
import Detective
import ComposableArchitecture
import Model
import Combine

public class Searcher {
    
    private let formatter = GTFormatter.Formatter()
    private var cancellables: Set<AnyCancellable> = []
    private let detective = Detective()
    
    public init() {}
    
    public func randomSong() -> Effect<SongDisplayModel?, Never> {
        detective.randomSong()
    }
    
    public func randomAlbum() -> Effect<AlbumDisplayModel?, Never> {
        detective.randomAlbum()
    }
    
    public func randomPerformance() -> Effect<PerformanceDisplayModel?, Never> {
        detective.randomPerformance()
    }
    
    public func search(_ search: Search) -> Effect<AnyModel?, Never> {
        
        guard let title = search.title else {
            if let id = search.id {
                return [detective.search(song: id),
                        detective.search(performance: id)]
                    .publisher
                    .flatMap(maxPublishers: .max(1)) { $0 }
                    .compactMap { $0 }
                    .replaceEmpty(with: nil)
                    .eraseToEffect()
            } else {
                fatalError()
            }
        }
        
        guard let type = search.type else {
            return [self.search(Search(title: title, type: .album)),
                    self.search(Search(title: title, type: .song)),
                    self.search(Search(title: title, type: .performance))]
                .publisher
                .flatMap(maxPublishers: .max(1)) { $0 }
                .compactMap { $0 }
                .replaceEmpty(with: nil)
                .eraseToEffect()
        }
        switch type {
        case .album:
            return detective.search(album: title)
        case .song:
            return detective.search(song: title)
        case .performance:
            if let toFetch = Double(title) ?? formatter.date(from: title) {
                return detective.fetch(performance: toFetch)
            } else {
                return Just(nil)
                    .eraseToEffect()
            }
        }
    }
    
}
