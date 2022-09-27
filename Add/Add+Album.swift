import Model
import Core
import Detective
class AlbumEditor {
    
    private let model: AlbumDisplayModel?
    
    init(_ model: AlbumDisplayModel?) {
        self.model = model
    }
    
    func editSong(_ song: String, with index: Int) -> sAlbum? {
        logger.log("Editing \(song, privacy: .public) at index \(index, privacy: .public)")
        var sAlbum = model?.album
        let detective = Detective()
        let uuid = detective.uuid(for: song)
        let song = sSong(uuid: uuid ?? .invalid, title: song, isFavorite: false)
        sAlbum?.songs[index] = song
        return sAlbum
    }
    
    func removeSong(at index: Int) -> sAlbum? {
        logger.log("Removing song at index \(index, privacy: .public)")
        var sAlbum = model?.album
        sAlbum?.songs.remove(at: index)
        return sAlbum
    }
    
    func createSong() -> sAlbum? {
        logger.log("Creating new song")
        var sAlbum = model?.album
        let newSong = sSong(uuid: .invalid, title: "", isFavorite: false)
        sAlbum?.songs.append(newSong)
        return sAlbum
    }
    
    func editTitle(_ title: String) -> sAlbum? {
        logger.log("Editing title \(title, privacy: .public)")
        var sAlbum = model?.album
        sAlbum?.title = title
        return sAlbum
    }
    
    func editDate(_ date: Date) -> sAlbum? {
        logger.log("Editing date to \(date, privacy: .public)")
        var sAlbum = model?.album
        sAlbum?.releaseDate = date.timeIntervalSince1970
        return sAlbum
    }
    
}
