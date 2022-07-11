//
//  Performance+CoreDataProperties.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//
//

import Foundation
import CoreData


extension Performance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Performance> {
        return NSFetchRequest<Performance>(entityName: "Performance")
    }

    @NSManaged public var date: Double
    @NSManaged public var lbNumbers: [Int]?
    @NSManaged public var venue: String?
    @NSManaged public var songs: NSOrderedSet?

}

// MARK: Generated accessors for songs
extension Performance {

    @objc(insertObject:inSongsAtIndex:)
    @NSManaged public func insertIntoSongs(_ value: Song, at idx: Int)

    @objc(removeObjectFromSongsAtIndex:)
    @NSManaged public func removeFromSongs(at idx: Int)

    @objc(insertSongs:atIndexes:)
    @NSManaged public func insertIntoSongs(_ values: [Song], at indexes: NSIndexSet)

    @objc(removeSongsAtIndexes:)
    @NSManaged public func removeFromSongs(at indexes: NSIndexSet)

    @objc(replaceObjectInSongsAtIndex:withObject:)
    @NSManaged public func replaceSongs(at idx: Int, with value: Song)

    @objc(replaceSongsAtIndexes:withSongs:)
    @NSManaged public func replaceSongs(at indexes: NSIndexSet, with values: [Song])

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSOrderedSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSOrderedSet)

}

extension Performance : Identifiable {

}
