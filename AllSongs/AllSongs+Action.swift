import Search
import CoreData

enum AllSongsViewAction {
    case selectSongPredicate(SongPredicate)
    case search(Search)
    case selectID(objectIdentifier: ObjectIdentifier?)
    case select(objectIdentifier: ObjectIdentifier?, id: NSManagedObjectID?)
}

public enum AllSongsFeatureAction {
    case search(SearchAction)
    case allSongs(AllSongsAction)
}

public enum AllSongsAction {
    case selectSongPredicate(SongPredicate)
}
