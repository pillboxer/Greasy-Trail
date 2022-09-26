public struct AlbumUploadModel: Equatable {

    public let recordName: String
    public let title: String
    public let releaseDate: Double
    public let uuids: [String]
    
    public init(recordName: String,
                title: String,
                releaseDate: Double,
                uuids: [String]) {
        self.title = title
        self.uuids = uuids
        self.releaseDate = releaseDate
        self.recordName = recordName
    }

}
