//
//  Deletable.swift
//  GTCoreData
//
//  Created by Henry Cooper on 07/08/2022.
//

import CoreData

public protocol Deletable: NSManagedObject {
    var markedAsDeleted: Bool { get set }
}
