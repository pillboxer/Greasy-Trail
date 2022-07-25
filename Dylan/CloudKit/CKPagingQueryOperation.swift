//
//  CKPagingQueryOperation.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 15/07/2022.
//

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
                   os_log("Cursor received in CKPagingQueryOperation, attempting query with cursor",
                          log: Log_CloudKit,
                          type: .debug)
                   let operation = CKPagingQueryOperation(query: query,
                                                          cursor: cursor,
                                                          database: database,
                                                          records: records)
                   operation.pagingCompletionBlock = pagingCompletionBlock
                   operation.errorBlock = errorBlock
                   operation.start()
               } else {
                   os_log("CKPagingQueryOperation complete, %{public}@ record(s) obtained",
                          log: Log_CloudKit,
                          String(describing: records.count))
                   pagingCompletionBlock?(records)
               }
            case .failure(let error):
                os_log("Error received in CKPagingQueryOperation: %{public}@",
                       log: Log_CloudKit,
                       type: .error,
                       String(describing: error))
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
