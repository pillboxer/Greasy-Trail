import Model
import Core
import BottomBar

public enum AddAction: Equatable {
    case selectRecordToAdd(DylanWork)

    // Songs
    case updateSong(title: String, author: String)
    case updateSongUUID(String?)
    
    // Albums
    case setAlbumSong(title: String, index: Int)
    case incrAlbumSongCount
    case updateAlbumTitle(String)
    case updateAlbumDate(Date)
    case updateAlbumDisplayModel(sAlbum?)
    
    // Performances
    case updatePerformanceVenue(String)
    case updatePerformanceDateFormat(PerformanceDateFormat)
    case updatePerformanceDate(Date)
    case updatePerformanceDisplayModel(sPerformance?)
    case removePerformanceSong(at: Int)
    case setPerformanceSong(title: String, index: Int)
    case incrPerformanceSongCount
    case setLB(lbNumber: Int, index: Int)
    case removeLB(at: Int)
    case incrLBCount
}
