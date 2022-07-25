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

class CloudKitManager: ObservableObject {
    
    enum CloudKitStep {
        case fetching(DylanRecordType)
        case uploading(String)
        case failure(String)
    }

    @UserDefaultsBacked(key: "last_fetch_date_songs") static var lastFetchDateSongs: Date?
    @UserDefaultsBacked(key: "last_fetch_date_albums") static var lastFetchDateAlbums: Date?
    @UserDefaultsBacked(key: "last_fetch_date_performances") static var lastFetchDatePerformances: Date?
    @UserDefaultsBacked(key: "last_fetch_date_appMetadata") static var lastFetchDateAppMetadata: Date?

    @Published private(set) var currentStep: CloudKitStep?
    @Published var progress: Double? = 0

    let database: DatabaseType
    let container: NSPersistentContainer

    init(_ database: DatabaseType,
         container: NSPersistentContainer = PersistenceController.shared.container) {
        self.database = database
        self.container = container
    }

    func start() async {
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
    func setCurrentStep(to step: CloudKitStep?) {
        currentStep = step
    }
    
    @MainActor func setProgress(to value: Double) {
        progress = value
    }
    
}

extension CloudKitManager {
    
    var fetchingType: DylanRecordType? {
        guard case let .fetching(type) = currentStep else {
            return nil
        }
        return type
    }
    
}

extension CloudKitManager {
    
    static func resetAllFetchDates() {
        lastFetchDateSongs = nil
        lastFetchDateAlbums = nil
        lastFetchDatePerformances = nil
        lastFetchDateAppMetadata = nil
    }
}
