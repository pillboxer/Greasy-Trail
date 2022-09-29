public struct SongUploadModel: Equatable {

    public let recordName: String
    public let title: String
    public let author: String?
    public let baseSongUUID: String?
    
    public init(recordName: String,
                title: String,
                author: String?,
                baseSongUUID: String?) {
        self.recordName = recordName
        self.title = title
        self.author = author
        self.baseSongUUID = baseSongUUID
    }

}
