import CloudKit
extension CloudKitClient {
    
    static func uploadRecords(
        _ records: [CKRecord],
        to database: DatabaseType = DylanDatabase,
        with continuation: AsyncThrowingStream<CloudKitClient.Event, Error>.Continuation) {
           
            let operation = CKModifyRecordsOperation(recordsToSave: records)
            operation.qualityOfService = .userInitiated
            database.add(operation)
            
            operation.perRecordProgressBlock = { _, progress in
                continuation.yield(.updateUploadProgress(to: progress))
            }
            
            operation.savePolicy = .changedKeys
            
            operation.modifyRecordsResultBlock = { result in
                switch result {
                case .failure(let error):
                    continuation.finish(throwing: error)
                default:
                    continuation.yield(.completeUpload)
                    continuation.finish()
                }
            }
            
            operation.perRecordSaveBlock = { _, result in
                switch result {
                case .failure(let error):
                    continuation.finish(throwing: error)
                default:
                    return
                }
            }
        }
}
