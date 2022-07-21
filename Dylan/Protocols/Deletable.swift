//
//  Deletable.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import CoreData

protocol Deletable: NSManagedObject {
    var markedAsDeleted: Bool { get set }
}
