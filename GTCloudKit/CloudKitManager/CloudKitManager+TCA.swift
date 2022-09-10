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

public struct CloudKitState: Equatable {
    public var downloadingRecordType: DylanRecordType?
    public var mode: Mode
    public var lastFetchDate: Date?
    
    public init(downloadingRecordType: DylanRecordType?,
                mode: Mode,
                lastFetchDate: Date?) {
        self.downloadingRecordType = downloadingRecordType
        self.mode = mode
        self.lastFetchDate = lastFetchDate
    }
}

public enum CloudKitAction {
    case start(date: Date?)
    case fetchSongs(Date?)
    case fetchAlbums(Date?, Bool)
    case fetchPerformances(Date?, Bool)
    case cloudKitClient(TaskResult<CloudKitClient.Event>)
    case completeDownload
}
