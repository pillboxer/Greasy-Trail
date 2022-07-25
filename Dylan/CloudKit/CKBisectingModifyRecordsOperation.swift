//
//  CKBisectingModifyRecordsOperation.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import CloudKit
import OSLog

class CKBisectingOperationManager {

    private(set) var runningOperationCount = 0
    private(set) var recordsSaved: [CKRecord] = []
    private(set) var recordIDsDeleted: [CKRecord.ID] = []

    func addOperation() {
        runningOperationCount += 1
        os_log("Adding Bisecting Operation: %{public}@ operations in progress",
               log: Log_CloudKit,
               type: .info,
               String(describing: runningOperationCount))

    }

    func finishOperation(_ savedRecords: [CKRecord]?, _ deletedRecordIDs: [CKRecord.ID]?) {
        if let savedRecords = savedRecords {
            recordsSaved.append(contentsOf: savedRecords)
        }
        if let deletedRecordIDs = deletedRecordIDs {
            recordIDsDeleted.append(contentsOf: deletedRecordIDs)
        }
        runningOperationCount -= 1
        os_log("Finished Bisecting Operation: %{public}@ operations remaining",
               log: Log_CloudKit,
               type: .info,
               String(describing: runningOperationCount))
    }

}

/// Keeps chopping its batches in half until it satisfies CloudKit's record limit
class CKBisectingModifyRecordsOperation {

    let recordsToSave: [CKRecord]?
    let recordIDsToDelete: [CKRecord.ID]?
    let database: DatabaseType
    let manager: CKBisectingOperationManager

    var perRecordProgressBlock: ((CKRecord, Double) -> Void)?

    var recordBatchCount: Int {
        (recordsToSave ?? []).count + (recordIDsToDelete ?? []).count
    }

    init(recordsToSave: [CKRecord]?,
         recordIDsToDelete: [CKRecord.ID]? = nil,
         manager: CKBisectingOperationManager = CKBisectingOperationManager(),
         database: DatabaseType) {
        self.manager = manager
        self.recordsToSave = recordsToSave
        self.recordIDsToDelete = recordIDsToDelete
        self.database = database
    }

    var bisectingModifyRecordsCompletionBlock: ((_ totalRecordsSaved: [CKRecord]?,
                                                 _ totalRecordsDeleted: [CKRecord.ID]?,
                                                 _ error: Error?) -> Void)?

    func start(bisecting: Bool = false) {
        manager.addOperation()

        if bisecting {
            os_log("Beginning Bisecting Operation with %{public}@ records",
                   log: Log_CloudKit,
                   type: .info,
                   String(describing: recordBatchCount))
        } else {
            os_log("Beginning Modification Operation with %{public}@ records",
                   log: Log_CloudKit,
                   type: .info,
                   String(describing: recordBatchCount))
        }

        if recordBatchCount > 400 {
            manager.finishOperation(nil, nil)
            bisect(records: recordsToSave, recordIDs: recordIDsToDelete)
            return
        }

        let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: recordIDsToDelete)
        operation.savePolicy = .changedKeys
        operation.perRecordProgressBlock = perRecordProgressBlock
        operation.qualityOfService = .userInitiated

        operation.modifyRecordsCompletionBlock = { [self] saved, deleted, error in
            manager.finishOperation(saved, deleted)
            if let error = error as? CKError,
               error.code == CKError.limitExceeded {
                bisect(records: recordsToSave, recordIDs: recordIDsToDelete)
            } else if let error = error {
                os_log("Unable to save records. Error %{public}@",
                       log: Log_CloudKit,
                       type: .error,
                       String(describing: error))
                bisectingModifyRecordsCompletionBlock?(nil, nil, error)
            } else {
                if manager.runningOperationCount == 0 {
                    bisectingModifyRecordsCompletionBlock?(manager.recordsSaved, manager.recordIDsDeleted, nil)
                }
            }
        }
        database.add(operation)
    }

    private func bisect(records: [CKRecord]?, recordIDs: [CKRecord.ID]?) {

        let savedRecords = self.recordsToSave ?? []
        let saveCount = savedRecords.count

        let deletedRecords = self.recordIDsToDelete ?? []
        let deleteCount = deletedRecords.count

        let recordsToSaveHalved = saveCount / 2
        let firstSaveBatch = Array(savedRecords[0..<recordsToSaveHalved])
        let secondSaveBatch = Array(savedRecords[recordsToSaveHalved..<saveCount])

        let recordsToDeleteHalved = deleteCount / 2
        let firstDeleteBatch = Array(deletedRecords[0..<recordsToDeleteHalved])
        let secondDeleteBatch = Array(deletedRecords[recordsToDeleteHalved..<deleteCount])

        os_log("Batch too large. Bisecting %d records into two batches of %d and %d",
               log: Log_CloudKit,
               type: .info,
               (savedRecords.count + deletedRecords.count),
               (firstSaveBatch.count + firstDeleteBatch.count),
               (secondSaveBatch.count + secondDeleteBatch.count))

        let firstOperation = CKBisectingModifyRecordsOperation(recordsToSave: firstSaveBatch,
                                                               recordIDsToDelete: firstDeleteBatch,
                                                               manager: manager,
                                                               database: database)
        let secondOperation = CKBisectingModifyRecordsOperation(recordsToSave: secondSaveBatch,
                                                                recordIDsToDelete: secondDeleteBatch,
                                                                manager: manager,
                                                                database: database)

        firstOperation.perRecordProgressBlock = perRecordProgressBlock
        firstOperation.bisectingModifyRecordsCompletionBlock = bisectingModifyRecordsCompletionBlock

        secondOperation.perRecordProgressBlock = perRecordProgressBlock
        secondOperation.bisectingModifyRecordsCompletionBlock = bisectingModifyRecordsCompletionBlock

        firstOperation.start(bisecting: true)
        secondOperation.start(bisecting: true)
    }
}
