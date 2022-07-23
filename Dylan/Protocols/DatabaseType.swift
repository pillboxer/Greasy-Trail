//
//  DatabaseType.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

typealias PagedResult = (id: CKRecord.ID, result: Result<RecordType, Error>)

protocol DatabaseType {
    func recordTypes(for ids: [CKRecord.ID],
                     desiredKeys: [CKRecord.FieldKey]?) async throws -> [CKRecord.ID: Result<RecordType, Error>]
    func fetchPagedResults(with query: CKQuery) async throws -> ([PagedResult])
    func add(_ operation: CKDatabaseOperation)
}

extension DatabaseType {

}
