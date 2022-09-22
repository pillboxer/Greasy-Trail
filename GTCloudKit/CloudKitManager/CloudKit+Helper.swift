import CloudKit
import OSLog
import Core

public let Log_CloudKit = OSLog(subsystem: .subsystem, category: "CloudKit Fetch")

func fetchRecords(of type: DylanRecordType, after date: Date?) async throws -> [RecordType] {
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
            os_log("ID was not found in song references. Continuing", log: Log_CloudKit, type: .error)
            continue
        }
        guard let recordType = try? result.get() else {
            let title = record.string(for: .title) ?? record.string(for: .venue) ?? ""
            let badName = id.recordName
            os_log("Unknown ID %{public}@ found in song records of %{public}@",
                   log: Log_CloudKit,
                   type: .error,
                   badName, title)
            continue
        }
        ordered.append(recordType)
    }
    return ordered
}
