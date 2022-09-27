import SwiftUI
import CoreData

public protocol TableViewType: View {
    // swiftlint:disable type_name
    associatedtype T: NSManagedObject, Identifiable
    var fetched: FetchedResults<T> { get }
    var sortOrder: [KeyPathComparator<T>] { get }
}

public extension TableViewType {

    var tableData: [T] {
        return fetched.sorted(using: sortOrder)
    }

}
