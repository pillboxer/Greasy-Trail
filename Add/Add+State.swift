import GTCloudKit
import Model
import GTFormatter
import Search
import BottomBar
import Core

public struct AddState: Equatable {
    
    var songTitleField = ""
    var songAuthorField = ""
    var songUUID: String?
    var performanceVenueField = ""
    var performanceDateField = Date()
    var performanceLBs: [Int] = []
    var performanceSongs: [sSong] = []
    
    public var selectedRecordToAdd: DylanWork
    public var search: SearchState
    
    private var model: AnyModel? {
        get {
            search.model
        }
        set {
            search.model = newValue
        }
    }
    
    var song: SongDisplayModel? {
        get {
            model?.value as? SongDisplayModel
        }
        set {
            guard let newValue = newValue else {
                return
            }
            model = AnyModel(newValue)
        }
    }
    
    fileprivate var album: AlbumDisplayModel? {
        get {
            model?.value as? AlbumDisplayModel
        }
        set {
            guard let newValue = newValue else {
                return
            }
            model = AnyModel(newValue)
        }
    }
    
    var performance: PerformanceDisplayModel? {
        get {
            model?.value as? PerformanceDisplayModel
        }
        set {
            guard let newValue = newValue else {
                return
            }
            model = AnyModel(newValue)
        }
    }
    
    public init(searchState: SearchState, selectedRecordToAdd: DylanWork) {
        self.selectedRecordToAdd = selectedRecordToAdd
        self.search = searchState
        if let model = model?.value as? SongDisplayModel {
            songTitleField = model.title
            songAuthorField = model.author
            songUUID = model.uuid
        } else if let model = model?.value as? PerformanceDisplayModel {
            performanceSongs = model.songs
            performanceLBs = model.lbNumbers
            performanceVenueField = model.venue
            performanceDateField = Date(timeIntervalSince1970: model.date)
        }
    }
}
