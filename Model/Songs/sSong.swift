import Foundation

// swiftlint:disable type_name
public struct sSong: Codable {
    
    public let uuid: String
    public let title: String
    public let author: String
    var performances: [sPerformance]?
    
    public init(uuid: String,
                title: String,
                author: String = NSLocalizedString("default_author", comment: ""),
                performances: [sPerformance]? = nil) {
        self.uuid = uuid
        self.title = title
        self.author = author
        self.performances = performances
    }
}

extension sSong: Equatable {

    public static func == (lhs: sSong, rhs: sSong) -> Bool {
        lhs.title == rhs.title
    }

}

extension sSong: Identifiable, Hashable {

    public var id: String {
        title
    }

}
