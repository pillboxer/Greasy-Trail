import Model
import Core
import CoreData

public enum SearchAction: Equatable {
    case selectID(objectIdentifier: ObjectIdentifier?)
    case select(objectIdentifier: ObjectIdentifier?, objectID: NSManagedObjectID?)
    case makeSearch(Search)
    case completeSearch(AnyModel?, Search)
    case makeRandomSearch
    case setSearchFieldText(String)
    case selectDisplayedView(DisplayedView, AnyModel?)
    case reset
}
