//
//  DatabaseType.swift
//  Dylan
//
//  Created by Henry Cooper on 25/06/2022.
//

import CloudKit

protocol DatabaseType {
    func recordTypes(for ids: [CKRecord.ID],desiredKeys: [CKRecord.FieldKey]?) async throws -> [CKRecord.ID : Result<RecordType, Error>]
    func fetchPagedResults(with query: CKQuery) async -> ([(CKRecord.ID, Result<RecordType, Error>)])
    func add(_ operation: CKDatabaseOperation)
}

extension DatabaseType {
    
}
