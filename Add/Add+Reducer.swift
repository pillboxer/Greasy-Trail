import Search
import ComposableArchitecture
import CasePaths
import Model
import Core

public let addReducer = Reducer<AddState, AddAction, Void> { state, action, _ in
    var actions: [Effect<AddAction>] = []
    switch action {
    case .selectRecordToAdd(let dylanRecordType):
        state.selectedRecordToAdd = dylanRecordType
    case .updateSong(let title, let author):
        let detective = Detective()
        let uuid = detective.uuid(for: title)
        let sSong = sSong(uuid: uuid ?? "", title: title, author: author)
        state.song = SongDisplayModel(song: sSong)
        return [.sync { .updateSongUUID(uuid) }]
    case .updateSongUUID(let uuid):
        state.songUUID = uuid
        
    case .incrLBCount:
        var lbs = state.performance?.lbNumbers ?? []
        if lbs.last == 0 { return [] }
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.appendLBNumber(0)
        return [.sync { .updatePerformanceDisplayModel(sPerformance) }]
    case .incrSongCount:
        var songs = state.performanceSongs
        if songs.last?.title == "" { return [] }
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.createSong()
        return [.sync { .updatePerformanceDisplayModel(sPerformance)}]
    case .removeLB(let index):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.removeLB(at: index)
        return [.sync { .updatePerformanceDisplayModel(sPerformance) }]
    case .removeSong(let index):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.removeSong(at: index)
        return [.sync { .updatePerformanceDisplayModel(sPerformance) }]
    case .setLB(let lbNumber, let index):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.setLB(lbNumber, at: index)
        return [.sync { .updatePerformanceDisplayModel(sPerformance) }]
    case .setSong(let song, let index):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.editSong(song, with: index)
        return [.sync { .updatePerformanceDisplayModel(sPerformance)}]
    case .updatePerformanceVenue(let string):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.editVenue(string)
        return [.sync { .updatePerformanceDisplayModel(sPerformance)}]
    case .updatePerformanceDate(let date):
        let performanceEditor = PerformanceEditor(state.performance)
        let sPerformance = performanceEditor.editDate(date)
        return [.sync { .updatePerformanceDisplayModel(sPerformance)}]
    case .updatePerformanceDisplayModel(let model):
        guard let model = model else { return [] }
        state.performance = PerformanceDisplayModel(sPerformance: model)
    }
    return actions
}

func findSongEffect(string: String) -> Effect<sSong> {
    let detective = Detective()
    return detective.fetchModel(for: string)
        .compactMap { $0?.value as? SongDisplayModel }
        .map { sSong(uuid: $0.uuid, title: $0.title, author: $0.author)}
        .eraseToEffect()
}
