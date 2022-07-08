//
//  Song+CoreDataProperties.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?

}

extension Song : Identifiable {

}
