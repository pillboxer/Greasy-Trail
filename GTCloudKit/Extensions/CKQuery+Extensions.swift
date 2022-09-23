import CloudKit
import Core

extension CKQuery {

    convenience init (recordType: DylanRecordType, predicate: NSPredicate = .init(value: true)) {
        self.init(recordType: recordType.rawValue, predicate: predicate)
    }

}
