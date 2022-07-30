//
//  CloudKitManager+Metadata.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//

import CloudKit
import SwiftUI
import os

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
    
    func upload(_ metdata: AppMetadata) async -> Result<CKRecord, Error> {
        // swiftlint: disable force_try
        let query = CKQuery(recordType: .appMetadata, predicate: .misspellings)
        // FIXME:
        let tuple = try? await database.fetchPagedResults(with: query).first
        guard let result = tuple?.result,
              let record = try? result.get() as? CKRecord else {
            // FIXME:

            return .failure(NSError(domain: "CloudKit", code: 999))
        }
        let context = container.newBackgroundContext()
        
        // swiftlint: disable force_cast
        context.performAndWait {
            let safeMetadata = context.object(with: metdata.objectID) as! AppMetadata
            record["file"] = safeMetadata.file
            print(try! (safeMetadata.file)!.decoded() as Misspellings)
        }
        return await withCheckedContinuation { continuation in
            _upload(record: record) { result in
                continuation.resume(returning: result)
            }

        }
    }
    
    // swiftlint: disable identifier_name
    func _upload(record: CKRecord, completion: @escaping (Result<CKRecord, Error>) -> Void) {
   
        let operation = CKBisectingModifyRecordsOperation(recordsToSave: [record], database: database)
        operation.start()
        operation.bisectingModifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let record = records?.first {
                completion(.success(record))
            } else {
                // FIXME:

                completion(.failure(NSError(domain: "CloudKit", code: 999)))
            }
        }
    }
    
}
