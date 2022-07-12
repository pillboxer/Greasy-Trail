//
//  Song+CoreDataClass.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//
//

import Foundation
import CoreData

@objc(Song)
public class Song: NSManagedObject {
    
    var songAuthor: String {
        author ?? "Bob Dylan"
    }

}
