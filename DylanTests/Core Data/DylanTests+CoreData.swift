//
//  DylanTests+CoreData.swift
//  DylanTests
//
//  Created by Henry Cooper on 08/07/2022.
//

import Foundation
import CoreData

@testable import Greasy_Trail

extension DylanTests {
    
    func album(_ context: NSManagedObjectContext, title: String, releaseDate: Double) -> Album {
        let album = Album(context: context)
        album.title = title
        album.releaseDate = releaseDate
        return album
    }
    
}
