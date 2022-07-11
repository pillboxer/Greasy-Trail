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
    @Published private(set) var currentStep: CloudKitFetchStep? = nil
    let database: DatabaseType
    let container: NSPersistentContainer
    
    enum CloudKitFetchStep: Int, CaseIterable {
        case songs 
        case albums
        case performances
    }
    
    init(_ database: DatabaseType, container: NSPersistentContainer = PersistenceController.shared.container) {
        self.database = database
        self.container = container
    }
    
    func start() async throws {
        let date = Date()
        os_log("CloudKitManager starting. Upon successful fetch, fetch time will be set to %@", log: Log_CloudKit, String(describing: date))
        do {
            lastFetchDate = nil
            await setCurrentStep(to: .songs)
            try await fetchLatestSongs()
            await setCurrentStep(to: .albums)
            try await fetchLatestAlbums()
            await setCurrentStep(to: .performances)
            try await fetchLatestPerformances()
            await setCurrentStep(to: nil)
            lastFetchDate = date
        }
        catch {
            fatalError("Failed at start")
        }
    }
    
    @MainActor
    private func setCurrentStep(to step: CloudKitFetchStep?) {
        let description = step == nil ? "nil" : String(describing: step!)
        os_log("Setting next fetch step to %@", log: Log_CloudKit, description)
        currentStep = step
    }
    
    // Fetching Many
    func fetchRecords(of type: DylanRecordType) async throws -> [RecordType] {
        os_log("Fetching records of type %@", log: Log_CloudKit, String(describing: type))
        let predicate = NSPredicate(format: "modificationDate > %@", (lastFetchDate ?? .distantPast) as NSDate)
        let query = CKQuery(recordType: type, predicate: predicate)
        let array = try await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        let records = array.compactMap { try? $0.1.get() }
        return records
    }

}



