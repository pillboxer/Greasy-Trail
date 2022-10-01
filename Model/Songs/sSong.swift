import Foundation

// swiftlint:disable type_name
public struct sSong: Decodable, Equatable {
    
    public let uuid: String
    public var title: String
    public var author: String
    public let isFavorite: Bool
    let performances: [sPerformance]?
    public var baseSongUUID: String?
    
    public init(uuid: String,
                title: String,
                author: String = NSLocalizedString("default_author", comment: ""),
                performances: [sPerformance]? = nil,
                isFavorite: Bool,
                baseSongUUID: String?) {
        self.uuid = uuid
        self.title = title
        self.author = author
        self.performances = performances
        self.isFavorite = isFavorite
        self.baseSongUUID = baseSongUUID
    }
}

extension sSong: Identifiable, Hashable {

    public var id: String {
        title
    }

}
