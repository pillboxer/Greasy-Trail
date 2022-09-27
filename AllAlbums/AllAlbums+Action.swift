import Search
import CoreData

enum AllAlbumsViewAction {
    case selectAlbumPredicate(AlbumPredicate)
    case search(Search)
    case selectID(objectIdentifier: ObjectIdentifier?)
    case select(objectIdentifier: ObjectIdentifier?, id: NSManagedObjectID?)
}

public enum AllAlbumsFeatureAction {
    case search(SearchAction)
    case allAlbums(AllAlbumsAction)
}

public enum AllAlbumsAction {
    case selectAlbumPredicate(AlbumPredicate)
}
