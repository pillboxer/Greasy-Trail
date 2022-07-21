//
//  CloudKitManager+Performances.swift
//  Dylan
//
//  Created by Henry Cooper on 05/07/2022.
//

import Foundation
import CloudKit
import OSLog
import CoreData

extension CloudKitManager {

    func fetchLatestPerformances() async throws {
        let records = try await fetch(.performance)

        // Store titles and release dates
        let venues = records.compactMap { $0.string(for: .venue) }
        let dates = records.compactMap { $0.double(for: .date) }
        let lbNumbers = records.map { $0.ints(for: .lbNumbers) }
        let context = container.newBackgroundContext()

        for (index, record) in records.enumerated() {
            await setProgress(to: Double(index) / Double(records.count))

            await setCurrentStep(to: .fetching(.performance))
            // Get the title and release date of the album
            let venue = venues[index]
            let date = dates[index]
            let lbs = lbNumbers[index]
            // Fetch the records
            let ordered = try await getOrderedSongRecords(from: record)
            // Get the Song objects
            let songTitles = ordered.compactMap { $0.string(for: .title) }
            let correspondingSongs: [Song] = songTitles.compactMap { title in
                let predicate = NSPredicate(format: "title == %@", title)
                return context.fetchAndWait(Song.self, with: predicate).first
            }

            context.performAndWait {
                // Check for existing performance
                let predicate = NSPredicate(format: "venue == %@ && date == %d", venue, Int(date))
                let existingPerformance = context.fetchAndWait(Performance.self, with: predicate).first
                // Create or update performance
                let performance = existingPerformance ?? Performance(context: context)
                performance.venue = venue
                performance.date = date
                performance.lbNumbers = lbs
                performance.uuid = record.recordID.recordName

                let orderedSet = NSOrderedSet(array: correspondingSongs)
                performance.songs = orderedSet
            }
        }
        context.saveWithTry()
    }

    func upload(_ performanceUploadModel: PerformanceUploadModel) async {
        let result = await _upload(performanceUploadModel)
        switch result {
        case .success:
            await setCurrentStep(to: nil)
        case .failure(let error):
            await setCurrentStep(to: .failure(String(describing: error)))
        }
    }

    private func _upload(_ performanceUploadModel: PerformanceUploadModel) async -> Result<Void, Error> {
        await setCurrentStep(to: .uploading(performanceUploadModel.venue))
        return await withCheckedContinuation { continuation in
            _upload(performanceUploadModel) { result in
                continuation.resume(returning: result)
            }
        }
    }

    // swiftlint:disable identifier_name
    func _upload(_ performanceUploadModel: PerformanceUploadModel,
                 completion: @escaping (Result<Void, Error>) -> Void) {
        let record = CKRecord(recordType: DylanRecordType.performance.rawValue)
        record["venue"] = performanceUploadModel.venue
        record["date"] = performanceUploadModel.date
        var refs: [CKRecord.Reference] = []
        for uuid in performanceUploadModel.uuids {
            let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: uuid), action: .none)
            refs.append(reference)
        }
        record["songs"] = refs
        let operation = CKModifyRecordsOperation(recordsToSave: [record])
        operation.qualityOfService = .userInitiated
        database.add(operation)
        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }

        }
    }

}
