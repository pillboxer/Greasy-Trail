//
//  AppMetadata+CoreDataProperties.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//
//

import Foundation
import CoreData

extension AppMetadata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppMetadata> {
        return NSFetchRequest<AppMetadata>(entityName: "AppMetadata")
    }

    @NSManaged public var file: Data?
    @NSManaged public var name: String?
    @NSManaged public var uuid: String?

}

extension AppMetadata: Identifiable {

}
