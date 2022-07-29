//
//  TwoColumnTableViewType.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import Foundation
import CoreData
import SwiftUI

protocol TwoColumnTableViewType: View {
    // swiftlint:disable type_name
    associatedtype T: NSManagedObject, Identifiable
    var selection: Set<T.ID> { get set }
    func doubleTap(on string: String, id: T.ID) -> _EndedGesture<TapGesture>
    func singleTap(id: T.ID) -> _EndedGesture<TapGesture>
    var fetched: FetchedResults<T> { get }
    var sortOrder: [KeyPathComparator<T>] { get }
}

extension TwoColumnTableViewType {

    var tableData: [T] {
        return fetched.sorted(using: sortOrder)
    }

}
