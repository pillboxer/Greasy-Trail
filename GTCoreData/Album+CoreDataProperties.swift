//
//  Album+CoreDataProperties.swift
//  Dylan
//
//  Created by Henry Cooper on 07/07/2022.
//
//

import Foundation
import CoreData

extension Album: Favoritable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var releaseDate: Double
    @NSManaged public var title: String?
    @NSManaged public var songs: NSOrderedSet?
    @NSManaged public var markedAsDeleted: Bool
    @NSManaged public var uuid: String?
    @NSManaged public var isFavorite: Bool

}

// MARK: Generated accessors for songs
extension Album {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}

extension Album: Identifiable {

    public var id: String {
        title ?? "" + String(releaseDate)
    }
}
