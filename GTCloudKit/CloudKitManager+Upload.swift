//
//  CloudKitManager+Upload.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import CloudKit

extension CloudKitManager {
    
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
                completion(.failure(CloudKitManagerError.unknown))
            }
        }
    }
}
