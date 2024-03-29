import Foundation
import CoreData

public protocol Model {
    var uuid: String { get }
    var uploadAllowed: Bool { get }
    var isFavorite: Bool { get }
}

@dynamicMemberLookup
public struct AnyModel {
    
    public var value: Model
    
    public init<T: Model>(_ model: T) {
        self.value = model
    }
    
    public subscript<LocalValue>(dynamicMember keyPath: KeyPath<Model, LocalValue>) -> LocalValue {
        self.value[keyPath: keyPath]
    }
    
}

extension AnyModel: Equatable {
    
    public static func == (lhs: AnyModel, rhs: AnyModel) -> Bool {
        guard lhs.value.uuid == rhs.value.uuid else {
            return false
        }
        if let lhPerformance = lhs.value as? PerformanceDisplayModel,
            let rhPerformance = rhs.value as? PerformanceDisplayModel {
            return lhPerformance == rhPerformance
        } else if let lhSong = lhs.value as? SongDisplayModel,
                  let rhSong = rhs.value as? SongDisplayModel {
            return lhSong == rhSong
        } else if let lhAlbum = lhs.value as? AlbumDisplayModel,
                  let rhAlbum = rhs.value as? AlbumDisplayModel {
            return lhAlbum == rhAlbum
        }
        return true
    }
}
