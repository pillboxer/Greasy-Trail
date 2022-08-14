//
//  CloudKitManager+Metadata.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//

import CloudKit
import SwiftUI
import os
import GTCoreData

extension CloudKitManager {
    
    func fetchLatestMetadata() async throws {
        let records = try await fetch(.appMetadata, after: Self.lastFetchDateAppMetadata)
        
        let fileNames = records.compactMap { $0.string(for: .name) }
        let files = records.compactMap { $0.data(for: .file) }
        let context = container.newBackgroundContext()
        
        context.syncPerform {
            for index in records.indices {
                let fileName = fileNames[index]
                let file = files[index]
                let predicate = NSPredicate(format: "name == %@", fileName)
                let existing = context.fetchAndWait(AppMetadata.self, with: predicate).first
                let record = existing ?? AppMetadata(context: context)
                record.file = file
                record.name = fileName
            }
            context.performSave()
        }
        if !records.isEmpty {
            Self.lastFetchDateAppMetadata = Date()
        }
    }
}

public extension CloudKitManager {
    // swiftlint: disable force_cast
    func upload(_ metdata: AppMetadata) async -> Result<CKRecord, Error> {
        let query = CKQuery(recordType: .appMetadata, predicate: .misspellings)
        do {
            let tuple = try await database.fetchPagedResults(with: query).first
            guard let result = tuple?.result else {
                return .failure(CloudKitManagerError.query(code: 0))
            }
            let record = try result.get() as! CKRecord
            let context = container.newBackgroundContext()
            context.performAndWait {
                let safeMetadata = context.object(with: metdata.objectID) as! AppMetadata
                record["file"] = safeMetadata.file
            }
            return await withCheckedContinuation { continuation in
                _upload(record: record) { result in
                    continuation.resume(returning: result)
                }
            }
        } catch {
            return .failure(error)
        }
    }
}
