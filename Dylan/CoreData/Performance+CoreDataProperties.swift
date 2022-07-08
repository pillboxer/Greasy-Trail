//
//  Performance+CoreDataProperties.swift
//  Dylan
//
//  Created by Henry Cooper on 07/07/2022.
//
//

import Foundation
import CoreData


extension Performance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Performance> {
        return NSFetchRequest<Performance>(entityName: "Performance")
    }

    @NSManaged public var date: Double
    @NSManaged public var venue: String?
    @NSManaged public var lbNumbers: Data?
    @NSManaged public var songs: NSOrderedSet?

}

// MARK: Generated accessors for song
extension Performance {

    @objc(addSongObject:)
    @NSManaged public func addToSong(_ value: Song)

    @objc(removeSongObject:)
    @NSManaged public func removeFromSong(_ value: Song)

    @objc(addSong:)
    @NSManaged public func addToSong(_ values: NSSet)

    @objc(removeSong:)
    @NSManaged public func removeFromSong(_ values: NSSet)

}

extension Performance : Identifiable {

}
