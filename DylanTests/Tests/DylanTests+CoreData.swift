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

    func song(title: String, author: String? = NSLocalizedString("default_author", comment: "")) -> Song {
        let context = container.viewContext
        let song = Song(context: context)
        song.title = title
        song.author = author
        context.saveWithTry()
        return song
    }

    func createAndSaveNewport1965() {
        let context = container.viewContext

        let songs = [song(title: DummyModel.tMaggiesFarm),
                     song(title: DummyModel.tLikeARollingStone),
                     song(title: DummyModel.tItTakesALotToLaugh)]
        let performance = Performance(context: context)
        performance.songs = NSOrderedSet(array: songs)
        performance.venue = DummyModel.tNewport1965
        performance.date = DummyModel.dNewport1965
        performance.lbNumbers = DummyModel.lbNewport1965
        context.saveWithTry()
    }

    func createAndSaveHighway61Revisited() {
        let context = container.viewContext

        let songs = [song(title: DummyModel.tLikeARollingStone),
                     song(title: DummyModel.tTombstoneBlues),
                     song(title: DummyModel.tItTakesALotToLaugh),
                     song(title: DummyModel.tFromABuick6),
                     song(title: DummyModel.tBalladOfAThinMan),
                     song(title: DummyModel.tQueenJaneApproximately),
                     song(title: DummyModel.tHighway61Revisited),
                     song(title: DummyModel.tJustLikeTomThumbsBlues),
                     song(title: DummyModel.tDesolationRow)
                     ]
        let album = Album(context: context)
        album.songs = NSOrderedSet(array: songs)
        album.title = DummyModel.tHighway61Revisited
        album.releaseDate = DummyModel.dHighway61Revisited
        context.saveWithTry()
    }

}
