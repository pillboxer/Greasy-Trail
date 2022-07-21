//
//  CKDatabase+Extensions.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit
import OSLog

extension CKDatabase: DatabaseType {

    func recordTypes(for ids: [CKRecord.ID],
                     desiredKeys: [CKRecord.FieldKey]?) async throws -> [CKRecord.ID: Result<RecordType, Error>] {
        let oldReturn = try await records(for: ids, desiredKeys: desiredKeys)
        var toReturn: [CKRecord.ID: Result<RecordType, Error>] = [:]
        for pair in oldReturn {
            let id = pair.key
            let result = pair.value.map { $0 as RecordType }
            toReturn[id] = result
        }
        return toReturn
    }

    func fetchPagedResults(with query: CKQuery) async -> ([(CKRecord.ID, Result<RecordType, Error>)]) {
        await withCheckedContinuation { contination in
            let operation = CKPagingQueryOperation(query: query, database: self)
            operation.pagingCompletionBlock = { results in
                contination.resume(returning: results)
            }
            operation.errorBlock = { _ in
                contination.resume(returning: [])
            }
            operation.start()
        }

    }

}
