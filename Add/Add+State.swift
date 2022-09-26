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
    
    var albumTitleField = ""
    var albumDateField = Date()
    var albumSongs: [sSong] = []
    
    var performanceVenueField = ""
    var performanceDateField = Date()
    var performanceDateFormat: PerformanceDateFormat = .full
    var performanceLBs: [Int] = []
    var performanceSongs: [sSong] = []
    
    public var displayedView: DisplayedView
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
    
    var album: AlbumDisplayModel? {
        get {
            model?.value as? AlbumDisplayModel
            ?? AlbumDisplayModel(album:
                                    sAlbum(uuid: "A\(UUID().uuidString)",
                                           title: "",
                                           songs: [],
                                           releaseDate: Date().timeIntervalSince1970,
                                           isFavorite: false))
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
            ?? PerformanceDisplayModel(
                sPerformance:
                    sPerformance(uuid: "P\(UUID().uuidString)",
                                 venue: "",
                                 songs: [],
                                 date: Date().timeIntervalSince1970,
                                 isFavorite: false,
                                 dateFormat: .full))
        }
        set {
            guard let newValue = newValue else {
                return
            }
            model = AnyModel(newValue)
        }
    }
    
    public init(searchState: SearchState, displayedView: DisplayedView) {
        self.displayedView = displayedView
        self.search = searchState
        if let model = model?.value as? SongDisplayModel {
            songTitleField = model.title
            songAuthorField = model.author
            songUUID = model.uuid
        } else if let model = model?.value as? PerformanceDisplayModel {
            performanceSongs = model.songs
            performanceLBs = model.lbNumbers
            performanceVenueField = model.venue
            performanceDateFormat = model.dateFormat
            performanceDateField = Date(timeIntervalSince1970: model.date)
        } else if let model = model?.value as? AlbumDisplayModel {
            albumSongs = model.songs
            albumTitleField = model.title
            albumDateField = Date(timeIntervalSince1970: model.releaseDate)
        }
    }
}
