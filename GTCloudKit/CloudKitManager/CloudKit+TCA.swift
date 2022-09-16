//
//  CloudKitManager+TCA.swift
//  GTCloudKit
//
//  Created by Henry Cooper on 10/09/2022.
//

import ComposableArchitecture
import GTCoreData
import OSLog
import CloudKit
import Model

let DylanContainer = CKContainer(identifier: "iCloud.Dylan")
let DylanDatabase = DylanContainer.publicCloudDatabase

public struct CloudKitState: Equatable {
    public var mode: Mode?
    public var lastFetchDate: Date?
    
    public init(mode: Mode?, lastFetchDate: Date?) {
        self.mode = mode
        self.lastFetchDate = lastFetchDate
    }
}

public enum CloudKitAction {
    case start(date: Date?)
    case fetchSongs(Date?)
    case fetchAlbums(Date?, Bool)
    case fetchPerformances(Date?, Bool)
    case uploadPerformance(PerformanceDisplayModel)
    case cloudKitClient(TaskResult<CloudKitClient.Event>)
    case completeDownload
    case completeUpload
}
