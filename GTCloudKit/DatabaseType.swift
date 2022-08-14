//
//  Protocols.swift
//  GTCloudKit
//
//  Created by Henry Cooper on 14/08/2022.
//

import CloudKit

public typealias PagedResult = (id: CKRecord.ID, result: Result<RecordType, Error>)

public protocol DatabaseType {
    func recordTypes(for ids: [CKRecord.ID],
                     desiredKeys: [CKRecord.FieldKey]?) async throws -> [CKRecord.ID: Result<RecordType, Error>]
    func fetchPagedResults(with query: CKQuery) async throws -> ([PagedResult])
    func add(_ operation: CKDatabaseOperation)
}

extension DatabaseType {}
