import Detective
import ComposableArchitecture
import CasePaths
import Model
import Core

public let addReducer = Reducer<AddState, AddAction, Void> { state, action, _ in
    switch action {
    case .selectRecordToAdd(let dylanRecordType):
        logger.log("Setting record to add as \(dylanRecordType.rawValue, privacy: .public)")
        state.displayedView = .add(dylanRecordType)
        
    // Songs
    case .updateSong(let title, let author, let baseSong):
        logger.log("Updating song: (Title: \(title, privacy: .public), Author: \(author, privacy: .public)")
        var songModel = state.song
        var song = songModel?.song
        song?.title = title
        song?.author = author
        song?.baseSongUUID = baseSong
        if let song = song {
            state.song = SongDisplayModel(song: song)
        }
        return .none
        
    // Albums
    case .setAlbumSong(let song, let index):
        let albumEditor = AlbumEditor(state.album)
        let sAlbum = albumEditor.editSong(song, with: index)
        return Effect(value: .updateAlbumDisplayModel(sAlbum))
    case .updateAlbumDisplayModel(let sAlbum):
        guard let sAlbum = sAlbum else { return .none }
        state.album = AlbumDisplayModel(album: sAlbum)
    case .incrAlbumSongCount:
        var songs = state.albumSongs
        if songs.last?.title == "" { return .none }
        let albumEditor = AlbumEditor(state.album)
        let sAlbum = albumEditor.createSong()
        return Effect(value: AddAction.updateAlbumDisplayModel(sAlbum))
    case .updateAlbumTitle(let string):
        let albumEditor = AlbumEditor(state.album)
        let sPerformance = albumEditor.editTitle(string)
        return Effect(value: AddAction.updateAlbumDisplayModel(sPerformance))
    case .updateAlbumDate(let date):
        let albumEditor = AlbumEditor(state.album)
        let sAlbum = albumEditor.editDate(date)
        return Effect(value: AddAction.updateAlbumDisplayModel(sAlbum))
    case .removeAlbumSong(let index):
        let albumEditor = AlbumEditor(state.album)
        let sAlbum = albumEditor.removeSong(at: index)
        return Effect(value: AddAction.updateAlbumDisplayModel(sAlbum))

    // Performances
    case .incrLBCount:
        var lbs = state.performance?.lbNumbers ?? []
        if lbs.last == 0 { return .none }
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.appendLBNumber()
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .incrPerformanceSongCount:
        var songs = state.performanceSongs
        if songs.last?.title == "" { return .none }
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.createSong()
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .removeLB(let index):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.removeLB(at: index)
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .removePerformanceSong(let index):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.removeSong(at: index)
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .setLB(let lbNumber, let index):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.setLB(lbNumber, at: index)
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .setPerformanceSong(let song, let index):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.editSong(song, with: index)
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .updatePerformanceVenue(let string):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.editVenue(string)
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .updatePerformanceDateFormat(let format):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.editDateFormat(format)
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .updatePerformanceDate(let date):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.editDate(date)
        return Effect(value: AddAction.updatePerformanceDisplayModel(sPerformance))
    case .updatePerformanceDisplayModel(let sPerformance):
        guard let sPerformance = sPerformance else { return .none }
        state.performance = PerformanceDisplayModel(sPerformance: sPerformance)
    }
    return .none
}

func findSongEffect(string: String) -> Effect<sSong, Never> {
    let detective = Detective()
    return detective.fetchSongModel(for: string)
        .compactMap { $0?.value as? SongDisplayModel }
        .map { sSong(uuid: $0.uuid,
                     title: $0.title,
                     author: $0.author,
                     isFavorite: $0.isFavorite,
                     baseSongUUID: $0.baseSongUUID)
        }
        .eraseToEffect()
}
