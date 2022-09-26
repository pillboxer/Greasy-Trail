import CoreData

public protocol Deletable: NSManagedObject {
    var markedAsDeleted: Bool { get set }
}

extension Album: Deletable {}
extension Performance: Deletable {}
extension Song: Deletable {}
