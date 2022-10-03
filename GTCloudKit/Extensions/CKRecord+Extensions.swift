import CloudKit

extension CKRecord: RecordType {

   public func references(of referenceType: DylanReferenceType) -> [ReferenceType] {
        retrieve(type: [CKRecord.Reference].self, fromPath: referenceType.rawValue) ?? []
    }

    func referenceName(for parameter: String) -> String? {
        (self[parameter] as? CKRecord.Reference)?.recordID.recordName
    }

    public func string(for field: DylanRecordField) -> String? {
        retrieve(type: String.self, fromPath: field.rawValue)
    }

   public func double(for field: DylanRecordField) -> Double? {
        retrieve(type: Double.self, fromPath: field.rawValue)
    }
    
    public func int(for field: DylanRecordField) -> Int? {
        retrieve(type: Int.self, fromPath: field.rawValue)
    }

   public func ints(for field: DylanRecordField) -> [Int]? {
        retrieve(type: [Int].self, fromPath: field.rawValue)
    }

   public func data(for field: DylanRecordField) -> Data? {
        retrieve(type: Data.self, fromPath: field.rawValue)
    }
    
    private func retrieve<T>(type: T.Type, fromPath path: String) -> T? {
        self[path] as? T
    }
}

extension CKRecord.Reference: ReferenceType {}
