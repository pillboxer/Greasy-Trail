import Model
import CloudKit
import Core

extension CloudKitClient {
    
    static func uploadPerformanceLive(from model: PerformanceUploadModel) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            continuation.yield(.updateUploadProgress(to: 0))
            let record = CKRecord(recordType: DylanRecordType.performance.rawValue,
                                  recordID: CKRecord.ID(recordName: model.recordName))
            var refs: [CKRecord.Reference] = []
            
            for uuid in model.uuids {
                let reference = CKRecord.Reference(recordID: .init(recordName: uuid),
                                                   action: .none)
                refs.append(reference)
            }
            record["songs"] = refs
            record["venue"] = model.venue
            record["date"] = model.date
            record["LBNumbers"] = model.lbs
            record["dateFormat"] = model.dateFormat.rawValue
            
            uploadRecords([record], with: continuation)
        }
    }
    
    static func uploadAlbumLive(from model: AlbumUploadModel) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            continuation.yield(.updateUploadProgress(to: 0))
            let record = CKRecord(recordType: DylanRecordType.album.rawValue,
                                  recordID: CKRecord.ID(recordName: model.recordName))
            var refs: [CKRecord.Reference] = []
            
            for uuid in model.uuids {
                let reference = CKRecord.Reference(recordID: .init(recordName: uuid),
                                                   action: .none)
                refs.append(reference)
            }
            record["songs"] = refs
            record["title"] = model.title
            record["releaseDate"] = model.releaseDate
            
            uploadRecords([record], with: continuation)
        }
    }
    
    private static func uploadRecords(
        _ records: [CKRecord],
        with continuation: AsyncThrowingStream<CloudKitClient.Event, Error>.Continuation) {
           
            let operation = CKModifyRecordsOperation(recordsToSave: records)
            operation.qualityOfService = .userInitiated
            DylanDatabase.add(operation)
            
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