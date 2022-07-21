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

    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?
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
        os_log("Progress is now %@", log: Log_CloudKit, String(describing: value))
        progress = value
    }

    enum CloudKitStep {
        case fetching(DylanRecordType)
        case uploading(String)
        case failure(String)
    }

    init(_ database: DatabaseType, container: NSPersistentContainer = PersistenceController.shared.container) {
        self.database = database
        self.container = container
    }

    func start(_ fetchAll: Bool = false) async throws {
        let date = Date()
        os_log("CloudKitManager starting. Upon successful fetch, fetch time will be set to %@",
               log: Log_CloudKit,
               String(describing: date))
        do {
            // Fix Me with deletion stuff
            if fetchAll {
                lastFetchDate = nil
            }
            subscribeToDatabase()
            try await fetchLatestSongs()
            try await fetchLatestAlbums()
            try await fetchLatestPerformances()
            await setCurrentStep(to: nil)
            lastFetchDate = date
        } catch {
            fatalError("Failed at start")
        }
    }

    func fetch(_ type: DylanRecordType) async throws -> [RecordType] {
        os_log("Fetching latest %@", log: Log_CloudKit, type.rawValue)
        await setProgress(to: 0)
        await setCurrentStep(to: .fetching(type))
        let records = try await fetchRecords(of: type)
        os_log("Found %@ records", log: Log_CloudKit, String(describing: records.count))
        return records
    }

    @MainActor
    func setCurrentStep(to step: CloudKitStep?) {
        let description = step == nil ? "nil" : String(describing: step!)
        os_log("Setting next fetch step to %@", log: Log_CloudKit, description)
        currentStep = step
    }

    // Fetching Many
    func fetchRecords(of type: DylanRecordType) async throws -> [RecordType] {
        os_log("Fetching records of type %@", log: Log_CloudKit, String(describing: type))
        let predicate = NSPredicate(format: "modificationDate > %@", (lastFetchDate ?? .distantPast) as NSDate)
        let query = CKQuery(recordType: type, predicate: predicate)
        let array = await database.fetchPagedResults(with: query)
        let records = array.compactMap { try? $0.1.get() }
        return records
    }

}
