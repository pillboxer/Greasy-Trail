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

    @UserDefaultsBacked(key: "last_fetch_date_songs") static var lastFetchDateSongs: Date?
    @UserDefaultsBacked(key: "last_fetch_date_albums") static var lastFetchDateAlbums: Date?
    @UserDefaultsBacked(key: "last_fetch_date_performances") static var lastFetchDatePerformances: Date?
    @UserDefaultsBacked(key: "last_fetch_date_appMetadata") static var lastFetchDateAppMetadata: Date?

    @Published private(set) var currentStep: CloudKitStep?
    let database: DatabaseType
    let container: NSPersistentContainer

    var fetchingType: DylanRecordType? {
        guard case let .fetching(type) = currentStep else {
            return nil
        }
        return type
    }

    @Published var progress: Double? = 0

    @MainActor func setProgress(to value: Double) {
        progress = value
    }

    enum CloudKitStep {
        case fetching(DylanRecordType)
        case uploading(String)
        case failure(String)
    }

    init(_ database: DatabaseType,
         container: NSPersistentContainer = PersistenceController.shared.container) {
        self.database = database
        self.container = container
    }

    func start() async throws {
        do {
            subscribeToDatabase()
            try await fetchLatestMetadata()
            try await fetchLatestSongs()
            try await fetchLatestAlbums()
            try await fetchLatestPerformances()
            await setCurrentStep(to: nil)
        } catch {
            fatalError("Failed at start")
        }
    }

    func fetch(_ type: DylanRecordType, after date: Date?) async throws -> [RecordType] {
        os_log("Fetching latest %@", log: Log_CloudKit, type.rawValue)
        await setProgress(to: 0)
        await setCurrentStep(to: .fetching(type))
        let records = try await fetchRecords(of: type, after: date)
        return records
    }

    @MainActor
    func setCurrentStep(to step: CloudKitStep?) {
        currentStep = step
    }

    // Fetching Many
    func fetchRecords(of type: DylanRecordType, after date: Date?) async throws -> [RecordType] {
        os_log("Fetching records of type %@", log: Log_CloudKit, String(describing: type))
        let predicate = NSPredicate(format: "modificationDate > %@", (date ?? .distantPast) as NSDate)
        let query = CKQuery(recordType: type, predicate: predicate)
        let array = await database.fetchPagedResults(with: query)
        let records = array.compactMap { try? $0.1.get() }
        return records
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
