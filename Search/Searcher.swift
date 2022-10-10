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
            if let uuid = search.uuid {
                return [detective.search(song: uuid),
                        detective.search(album: uuid),
                        detective.search(performance: uuid)].erased()
            } else if let id = search.id {
                return [detective.search(song: id),
                        detective.search(performance: id),
                        detective.search(album: id)].erased()
            } else {
                fatalError()
            }
        }
        guard let type = search.type else {
            return [self.search(Search(title: title, type: .album)),
                    self.search(Search(title: title, type: .song)),
                    self.search(Search(title: title, type: .performance))].erased()
        }
        switch type {
        case .album:
            return detective.search(album: title)
        case .song:
            return detective.search(song: title)
        case .performance:
            if let toFetch = Double(title) ?? formatter.date(from: title) {
                return detective.fetchPerformanceModel(for: toFetch)
            } else { return Just(nil) .eraseToEffect() }
        }
    }
}

private extension Array where Element == Effect<AnyModel?, Never> {
    
    func erased() -> Effect<AnyModel?, Never> {
        self
            .publisher
            .flatMap { $0 }
            .filter { $0 != nil }
            .replaceEmpty(with: nil)
            .eraseToEffect()
    }
    
}
