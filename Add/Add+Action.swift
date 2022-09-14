// swiftlint: disable identifier_name
import Model
import Core
import BottomBar

public enum AddAction: Equatable {
    case selectRecordToAdd(DylanWork)

    // Songs
    case updateSong(title: String, author: String)
    case updateSongUUID(String?)
    
    // Performances
    case incrLBCount
    case incrSongCount
    case removeLB(at: Int)
    case setLB(lbNumber: Int, index: Int)
    case setSong(title: String, index: Int)
    case updatePerformanceVenue(String)
    case updatePerformanceDate(Date)
    case updatePerformanceDisplayModel(sPerformance?)
    case removeSong(at: Int)
}
