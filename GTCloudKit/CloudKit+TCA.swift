import ComposableArchitecture
import CloudKit
import Model
import Core
import os
import StoreKit

let DylanContainer = CKContainer(identifier: "iCloud.Dylan")
let DylanDatabase = DylanContainer.publicCloudDatabase
let PrivateDatabase = DylanContainer.privateCloudDatabase
let logger = Logger(subsystem: .subsystem, category: "Cloud Kit")

public struct CloudKitState: Equatable {
    public var mode: Mode?
    public var lastFetchDate: Date?
    public var displaysAdminFunctionality: Bool
    public var amountDonated: Double
    
    public init(mode: Mode?, lastFetchDate: Date?, displaysAdminFunctionality: Bool, amountDonated: Double) {
        self.mode = mode
        self.lastFetchDate = lastFetchDate
        self.displaysAdminFunctionality = displaysAdminFunctionality
        self.amountDonated = amountDonated
    }
}

public enum CloudKitAction {
    case subscribeToDatabases
    case start(date: Date?)
    
    case fetchAdminMetadata
    case fetchPurchases
    case fetchSongs(Date?)
    case fetchAlbums(Date?, Bool)
    case fetchPerformances(Date?, Bool)

    case cloudKitClient(TaskResult<CloudKitClient.Event>)
    case completeDownload
    
    case uploadAlbum(AlbumDisplayModel)
    case uploadPerformance(PerformanceDisplayModel)
    case uploadSong(SongDisplayModel)
    case uploadPurchase(Product, PurchaseType)
}
