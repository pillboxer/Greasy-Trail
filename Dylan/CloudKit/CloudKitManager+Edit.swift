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
    func edit(_ fields: [DylanRecordField],
              on record: DylanRecordType,
              with uuid: String,
              to values: [CKRecordValue]) async -> Result<CKRecord, Error> {
        let id = CKRecord.ID(recordName: uuid)
        let predicate = NSPredicate(format: "recordID == %@", id)
        let query = CKQuery(recordType: record, predicate: predicate)
        
        guard fields.count == values.count else {
            fatalError("Unbalanced edit call")
        }
        
        do {
            let tuple = try await database.fetchPagedResults(with: query).first
            guard let result = tuple?.result else {
                return .failure(CloudKitManagerError.query(code: 0))
            }
            let record = try result.get() as! CKRecord
            for (index, field) in fields.enumerated() {
                record[field.rawValue] = values[index]
            }
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
