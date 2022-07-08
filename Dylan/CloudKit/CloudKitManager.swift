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
        print("** CK INIT")
    }
    
    func start() async throws {
        let date = Date()
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
        currentStep = step
    }
    
    // Fetching Many
    func fetchRecords(of type: DylanRecordType) async throws -> [RecordType] {
        let predicate = NSPredicate(format: "modificationDate > %@", (lastFetchDate ?? .distantPast) as NSDate)
        let query = CKQuery(recordType: type, predicate: predicate)
        
        let array = try await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        let records = array.compactMap { try? $0.1.get() }
        return records
    }
    
    // Fetching One
    func fetch(with title: String, recordType: DylanRecordType) async throws -> [(CKRecord.ID, Result<RecordType, Error>)] {
        os_log("Fetching %@ with title: %@", log: Log_CloudKit, recordType.rawValue.lowercased(), title)
        
        let predicate = NSPredicate(format: "title == %@", title)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        let records = try await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        
        os_log("Found %@ records matching", log: Log_CloudKit, String(describing: records.count))
        return records
    }
    
    func fetch(with date: Double, recordType: DylanRecordType) async throws ->  [(CKRecord.ID, Result<RecordType, Error>)] {
        os_log("Fetching %@ with date: %@", log: Log_CloudKit, recordType.rawValue.lowercased(), String(date))
        
        let predicate = NSPredicate(format: "date == %d", Int(date))
        let query = CKQuery(recordType: recordType, predicate: predicate)
       
        let records = try await database.recordTypes(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults).matchResults
        
        os_log("Found %@ records matching", log: Log_CloudKit, String(describing: records.count))
        return records
    }

}



