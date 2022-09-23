import Foundation
import CloudKit
import OSLog

class CKPagingQueryOperation {

    var pagingCompletionBlock: (([(CKRecord.ID, Result<RecordType, Error>)]) -> Void)?
    var errorBlock: ((Error) -> Void)?

    var cursor: CKQueryOperation.Cursor?
    var query: CKQuery

    let database: DatabaseType
    var records: [(CKRecord.ID, Result<RecordType, Error>)]

    init(query: CKQuery,
         cursor: CKQueryOperation.Cursor? = nil,
         database: DatabaseType,
         records: [(CKRecord.ID, Result<RecordType, Error>)] = []) {
        self.cursor = cursor
        self.database = database
        self.query = query
        self.records = records
    }

    func start() {
        let operation = CKQueryOperation(cursor: cursor, query: query)
        operation.qualityOfService = .userInitiated
        let completionBlock: ((Result<CKQueryOperation.Cursor?, Error>) -> Void)? = { [self] result in
            
            switch result {
            case .success(let cursor):
                if let cursor = cursor {
                   let operation = CKPagingQueryOperation(query: query,
                                                          cursor: cursor,
                                                          database: database,
                                                          records: records)
                   operation.pagingCompletionBlock = pagingCompletionBlock
                   operation.errorBlock = errorBlock
                   operation.start()
               } else {
                   pagingCompletionBlock?(records)
               }
            case .failure(let error):
                logger.log(
                    level: .error,
                    "Error received in CKPagingQueryOperation: \(String(describing: error), privacy: .public)")
                errorBlock?(error)
            }
        }
        operation.recordMatchedBlock = { (id, record) in
            let mapped = record.map { $0 as RecordType }
            self.records.append((id, mapped))
        }

        operation.queryResultBlock = completionBlock
        database.add(operation)
    }
}
