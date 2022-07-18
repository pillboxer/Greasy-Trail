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
    @Published private(set) var currentStep: CloudKitStep? = nil
    let database: DatabaseType
    let container: NSPersistentContainer
    
    enum CloudKitStep {
        case fetching(String)
        case songs(String)
        case albums(String)
        case performances(String)
        case uploading(String)
        case failure(String)
    }
    
    init(_ database: DatabaseType, container: NSPersistentContainer = PersistenceController.shared.container) {
        self.database = database
        self.container = container
    }
    
    func start(_ fetchAll: Bool = false) async throws {
        let date = Date()
        os_log("CloudKitManager starting. Upon successful fetch, fetch time will be set to %@", log: Log_CloudKit, String(describing: date))
        do {
            // Fix Me with deletion stuff
            if fetchAll {
                lastFetchDate = nil
            }
            subscribeToDatabase()
            await setCurrentStep(to: .fetching(DylanRecordType.song.rawValue))
            try await fetchLatestSongs()
            await setCurrentStep(to: .fetching(DylanRecordType.album.rawValue))
            try await fetchLatestAlbums()
            await setCurrentStep(to: .fetching(DylanRecordType.performance.rawValue))
            try await fetchLatestPerformances()
            await setCurrentStep(to: nil)
            lastFetchDate = date
        }
        catch {
            fatalError("Failed at start")
        }
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



