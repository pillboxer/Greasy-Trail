//
//  CloudKitManager.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import Foundation
import CloudKit
import CoreData
import OSLog
import GTCoreData
import GTLogging
import Core

// swiftlint:disable identifier_name
let DylanContainer = CKContainer(identifier: "iCloud.Dylan")
public let DylanDatabase = DylanContainer.publicCloudDatabase

public class CloudKitManager: ObservableObject {
    
    public enum CloudKitStep: Equatable {
        case fetching(DylanRecordType)
        case uploading(String)
        case failure(String)
    }

    @UserDefaultsBacked(key: "last_fetch_date_songs") static var lastFetchDateSongs: Date?
    @UserDefaultsBacked(key: "last_fetch_date_albums") static var lastFetchDateAlbums: Date?
    @UserDefaultsBacked(key: "last_fetch_date_performances") static var lastFetchDatePerformances: Date?
    @UserDefaultsBacked(key: "last_fetch_date_appMetadata") static var lastFetchDateAppMetadata: Date?

    @Published private(set) public var currentStep: CloudKitStep?
    @Published public var progress: Double? = 0

    let database: DatabaseType
    let container: NSPersistentContainer

    public init(_ database: DatabaseType = DylanDatabase,
                container: NSPersistentContainer = PersistenceController.shared.container) {
        self.database = database
        self.container = container
    }

    public func start() async {
        subscribeToDatabase()
        do {
            try await fetchLatestMetadata()
            try await fetchLatestSongs()
            try await fetchLatestAlbums()
            try await fetchLatestPerformances()
        } catch {
            os_log("Failed at start() with error: %{public}@",
                   log: Log_CloudKit,
                   type: .error,
                   String(describing: error))
            await setCurrentStep(to: .failure(String(describing: error)))
            return
        }
        await setCurrentStep(to: nil)
    }

    func fetch(_ type: DylanRecordType, after date: Date?) async throws -> [RecordType] {
        os_log("Fetching latest %{public}@", log: Log_CloudKit, type.rawValue)
        await setProgress(to: 0)
        await setCurrentStep(to: .fetching(type))
        let records = try await fetchRecords(of: type, after: date)
        os_log("%{public}@ %{public}@ objects fetched", log: Log_CloudKit,
               String(describing: records.count),
               String(describing: type.rawValue))
        return records
    }

    func fetchRecords(of type: DylanRecordType, after date: Date?) async throws -> [RecordType] {
        os_log("Fetching records of type %{public}@", log: Log_CloudKit, String(describing: type))
        let predicate = NSPredicate(format: "modificationDate > %@", (date ?? .distantPast) as NSDate)
        let query = CKQuery(recordType: type, predicate: predicate)
        let array = try await database.fetchPagedResults(with: query)
        let records = array.compactMap { try? $0.result.get() }
        return records
    }

}

extension CloudKitManager {
    
    @MainActor
    public func setCurrentStep(to step: CloudKitStep?) {
        currentStep = step
    }
    
    @MainActor func setProgress(to value: Double) {
        progress = value
    }
    
}

public extension CloudKitManager {
    
    var fetchingType: DylanRecordType? {
        guard case let .fetching(type) = currentStep else {
            return nil
        }
        return type
    }
    
}

public extension CloudKitManager {
    
    static func resetAllFetchDates() {
        lastFetchDateSongs = nil
        lastFetchDateAlbums = nil
        lastFetchDatePerformances = nil
        lastFetchDateAppMetadata = nil
    }
}

func fetch(_ type: DylanRecordType, after date: Date?) async throws -> [RecordType] {
    try await fetchRecords(of: type, after: date)
}

func fetchRecords(of type: DylanRecordType, after date: Date?) async throws -> [RecordType] {
    let predicate = NSPredicate(format: "modificationDate > %@", (date ?? .distantPast) as NSDate)
    let query = CKQuery(recordType: type, predicate: predicate)
    let array = try await DylanDatabase.fetchPagedResults(with: query)
    let records = array.compactMap { try? $0.result.get() }
    return records
}

func getOrderedSongRecords(from record: RecordType) async throws -> [RecordType] {
    let songReferences = record.references(of: .songs)
    let ids = songReferences.compactMap { $0.recordID }

    // Fetch the records
    let dict = try await DylanDatabase.recordTypes(for: ids, desiredKeys: nil)
    var ordered: [RecordType] = []

    // Ensure songs are in the correct order
    for id in ids {
        guard let result = dict[id] else {
            os_log("ID was not found in song references. Continuing", log: Log_CloudKit, type: .error)
            continue
        }
        guard let recordType = try? result.get() else {
            let title = record.string(for: .title) ?? record.string(for: .venue) ?? ""
            let badName = id.recordName
            os_log("Unknown ID %{public}@ found in song records of %{public}@",
                   log: Log_CloudKit,
                   type: .error,
                   badName, title)
            continue
        }
        ordered.append(recordType)
    }
    return ordered
}
