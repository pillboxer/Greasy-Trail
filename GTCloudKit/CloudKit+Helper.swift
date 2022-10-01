import CloudKit
import os
import Core

func fetchRecords(of type: DylanRecordType, after date: Date? = nil) async throws -> [RecordType] {
    let predicate = NSPredicate(format: "modificationDate > %@", (date ?? .distantPast) as NSDate)
    let query = CKQuery(recordType: type, predicate: predicate)
    let array = try await DylanDatabase.fetchPagedResults(with: query)
    let records = array.compactMap { try? $0.result.get() }
    return records
}

func getOrderedSongRecords(from record: RecordType) async throws -> [RecordType] {
    let songReferences = record.references(of: .songs)
    let ids = songReferences.compactMap { $0.recordID }

    // Fetch the records
    let dict = try await DylanDatabase.recordTypes(for: ids, desiredKeys: nil)
    var ordered: [RecordType] = []

    // Ensure songs are in the correct order
    for id in ids {
        guard let result = dict[id] else {
            logger.log(
                level: .error,
                "ID \(id.recordName, privacy: .public) was not found in song references. Continuing"
            )
            continue
        }
        guard let recordType = try? result.get() else {
            let title = record.string(for: .title) ?? record.string(for: .venue) ?? ""
            let badName = id.recordName
            logger.log(
                level: .error,
                "Unknown ID \(badName, privacy: .public) found in song records of \(title, privacy: .public)")
            continue
        }
        ordered.append(recordType)
    }
    return ordered
}
