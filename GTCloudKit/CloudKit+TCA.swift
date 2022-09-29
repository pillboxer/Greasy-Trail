import ComposableArchitecture
import CloudKit
import Model
import Core
import os

let DylanContainer = CKContainer(identifier: "iCloud.Dylan")
let DylanDatabase = DylanContainer.publicCloudDatabase
let logger = Logger(subsystem: .subsystem, category: "Cloud Kit")

public struct CloudKitState: Equatable {
    public var mode: Mode?
    public var lastFetchDate: Date?
    
    public init(mode: Mode?, lastFetchDate: Date?) {
        self.mode = mode
        self.lastFetchDate = lastFetchDate
    }
}

public enum CloudKitAction {
    case subscribeToDatabases
    case start(date: Date?)
    
    case fetchSongs(Date?)
    case fetchAlbums(Date?, Bool)
    case fetchPerformances(Date?, Bool)

    case cloudKitClient(TaskResult<CloudKitClient.Event>)
    case completeDownload
    
    case uploadAlbum(AlbumDisplayModel)
    case uploadPerformance(PerformanceDisplayModel)
    case uploadSong(SongDisplayModel)
}
