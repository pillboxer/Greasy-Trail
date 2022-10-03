import CloudKit

public protocol RecordType {
    var recordID: CKRecord.ID { get }
    func string(for field: DylanRecordField) -> String?
    func ints(for field: DylanRecordField) -> [Int]?
    func double(for field: DylanRecordField) -> Double?
    func int(for field: DylanRecordField) -> Int?
    func data(for field: DylanRecordField) -> Data?
    func references(of referenceType: DylanReferenceType) -> [ReferenceType]
    var modificationDate: Date? { get }
}

extension RecordType {
    
    func string(for field: DylanRecordField) -> String? {
        nil
    }
    
    func ints(for field: DylanRecordField) -> [Int]? {
        nil
    }
    
    func double(for field: DylanRecordField) -> Double? {
        nil
    }
    
    func int(for field: DylanRecordField) -> Int? {
        nil
    }
    
    func data(for field: DylanRecordField) -> Data? {
        nil
    }
    
    func references(of referenceType: DylanReferenceType) -> [ReferenceType] {
        []
    }
    
    var modificationDate: Date? {
        .distantPast
    }
    
}
