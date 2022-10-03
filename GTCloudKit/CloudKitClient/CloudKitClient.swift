import Model
import Core

public struct CloudKitEnvironment {
    var client: CloudKitClient
    
    public init(client: CloudKitClient) {
        self.client = client
    }
}

public struct CloudKitClient {
    var fetchAdminMetadata: @Sendable () -> AsyncThrowingStream<Event, Error>
    var fetchPurchases: @Sendable () -> AsyncThrowingStream<Event, Error>
    var fetchSongs: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var fetchAlbums: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var fetchPerformances: @Sendable (_ after: Date?) -> AsyncThrowingStream<Event, Error>
    var uploadPerformance: @Sendable (_ model: PerformanceUploadModel) -> AsyncThrowingStream<Event, Error>
    var uploadAlbum: @Sendable (_ model: AlbumUploadModel) -> AsyncThrowingStream<Event, Error>
    var uploadSong: @Sendable (_ model: SongUploadModel) -> AsyncThrowingStream<Event, Error>
    var uploadPurchase: @Sendable (_ model: PurchaseUploadModel) -> AsyncThrowingStream<Event, Error>

    var subscribeToDatabases: @Sendable () -> Void
    
    public enum Event: Equatable {
        case updateFetchProgress(of: DylanRecordType, to: Double)
        case updateUploadProgress(to: Double)
        case completeFetch(newValues: Bool)
        case completeUpload
        case adminCheckPassed
        case updateAmountDonated(Double)
    }
}

extension CloudKitClient {
    
    public static let live = CloudKitClient(
        fetchAdminMetadata: {
            fetchAdminMetadataLive()
        }, fetchPurchases: {
            fetchPurchasesLive()
        }, fetchSongs: { date in
            fetchSongsLive(after: date)
        }, fetchAlbums: { date in
            fetchAlbumsLive(after: date)
        }, fetchPerformances: { date in
            fetchPerformancesLive(after: date)
        }, uploadPerformance: { model in
            uploadPerformanceLive(from: model)
        }, uploadAlbum: { model in
            uploadAlbumLive(from: model)
        }, uploadSong: { model in
            uploadSongLive(from: model)
        }, uploadPurchase: { model in
            uploadPurchaseLive(from: model)
        }, subscribeToDatabases: {
            subscribeToDatabasesLive()
        }
    )    
}
