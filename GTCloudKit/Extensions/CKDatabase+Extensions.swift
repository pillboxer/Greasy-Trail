import CloudKit
import OSLog

extension CKDatabase: DatabaseType {
    
    public func recordTypes(for ids: [CKRecord.ID],
                            desiredKeys: [CKRecord.FieldKey]?) async throws ->
    [CKRecord.ID: Result<RecordType, Error>] {
        let oldReturn = try await records(for: ids, desiredKeys: desiredKeys)
        var toReturn: [CKRecord.ID: Result<RecordType, Error>] = [:]
        for pair in oldReturn {
            let id = pair.key
            let result = pair.value.map { $0 as RecordType }
            toReturn[id] = result
        }
        return toReturn
    }
    
    public func fetchPagedResults(with query: CKQuery) async throws -> ([PagedResult]) {
        try await withCheckedThrowingContinuation { contination in
            let operation = CKPagingQueryOperation(query: query, database: self)
            operation.pagingCompletionBlock = { results in
                contination.resume(returning: results)
            }
            operation.errorBlock = { error in
                contination.resume(throwing: error)
            }
            operation.start()
        }
        
    }
    
}
