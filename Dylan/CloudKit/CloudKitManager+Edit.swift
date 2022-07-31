//
//  CloudKitManager+Edit.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 30/07/2022.
//

import Foundation
import CloudKit

extension CloudKitManager {
    
    // swiftlint: disable force_cast
    func edit(_ field: DylanRecordField,
              on record: DylanRecordType,
              with uuid: String,
              to value: CKRecordValue) async -> Result<CKRecord, Error> {
        let id = CKRecord.ID(recordName: uuid)
        let predicate = NSPredicate(format: "recordID == %@", id)
        let query = CKQuery(recordType: record, predicate: predicate)
        
        do {
            let tuple = try await database.fetchPagedResults(with: query).first
            guard let result = tuple?.result else {
                return .failure(CloudKitManagerError.query(code: 0))
            }
            let record = try result.get() as! CKRecord
            record[field.rawValue] = value
            return await withCheckedContinuation { continuation in
                _upload(record: record) { bool in
                    continuation.resume(returning: bool)
                }

            }
        } catch {
            return .failure(error)
        }
    }
}
