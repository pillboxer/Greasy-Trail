import Foundation
import Core

public struct PerformanceUploadModel: Equatable {

    public let recordName: String
    public let venue: String
    public let date: Double
    public let lbs: [Int]
    public let uuids: [String]
    public let dateFormat: PerformanceDateFormat
    
    public init(recordName: String,
                venue: String,
                date: Double,
                lbs: [Int],
                uuids: [String],
                dateFormat: PerformanceDateFormat) {
        self.venue = venue
        self.lbs = lbs
        self.date = date
        self.uuids = uuids
        self.recordName = recordName
        self.dateFormat = dateFormat
    }

}
