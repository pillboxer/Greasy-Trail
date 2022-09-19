import Model
import Detective

class PerformanceEditor {
    
    private let model: PerformanceDisplayModel?
    
    init(_ model: PerformanceDisplayModel?) {
        self.model = model
    }
    
    func removeSong(at index: Int) -> sPerformance? {
        var sPerformance = model?.sPerformance
        sPerformance?.songs.remove(at: index)
        return sPerformance
    }
    
    func editVenue(_ venue: String) -> sPerformance? {
        var sPerformance = model?.sPerformance
        sPerformance?.venue = venue
        return sPerformance
    }
    
    func removeLB(at index: Int) -> sPerformance? {
        var sPerformance = model?.sPerformance
        sPerformance?.lbNumbers.remove(at: index)
        return sPerformance
    }
    
    func appendLBNumber(_ number: Int) -> sPerformance? {
        var sPerformance = model?.sPerformance
        sPerformance?.lbNumbers.append(number)
        return sPerformance
    }
    
    func setLB(_ int: Int, at index: Int) -> sPerformance? {
        var sPerformance = model?.sPerformance
        sPerformance?.lbNumbers[index] = int
        return sPerformance
    }
    
    func editSong(_ song: String, with index: Int) -> sPerformance? {
        var sPerformance = model?.sPerformance
        let trimmed = song.trimmingCharacters(in: .whitespacesAndNewlines)
        let detective = Detective()
        let uuid = detective.uuid(for: trimmed)
        let song = sSong(uuid: uuid ?? .invalid, title: trimmed, isFavorite: false)
        sPerformance?.songs[index] = song
        return sPerformance
    }
    
    func createSong() -> sPerformance? {
        var sPerformance = model?.sPerformance
        let newSong = sSong(uuid: .invalid, title: "", isFavorite: false)
        sPerformance?.songs.append(newSong)
        return sPerformance
    }
    
    func editDate(_ date: Date) -> sPerformance? {
        var sPerformance = model?.sPerformance
        sPerformance?.date = date.timeIntervalSince1970
        return sPerformance
    }
    
}
