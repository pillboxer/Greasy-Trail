//
//  TwoColumnTable.swift
//  TwoColumnTable
//
//  Created by Henry Cooper on 07/08/2022.
//

import SwiftUI
import CoreData

public protocol TwoColumnTableViewType: View {
    // swiftlint:disable type_name
    associatedtype T: NSManagedObject, Identifiable
    var fetched: FetchedResults<T> { get }
    var sortOrder: [KeyPathComparator<T>] { get }
}

public extension TwoColumnTableViewType {

    var tableData: [T] {
        return fetched.sorted(using: sortOrder)
    }

}
