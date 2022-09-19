import CoreData
public protocol Favoritable: NSManagedObject {
    var isFavorite: Bool { get set }
}
