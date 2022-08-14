//
//  PerformanceUploadModel.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import Foundation

public struct PerformanceUploadModel {

    public let venue: String
    public let date: Double
    public let uuids: [String]
    
    public init(venue: String, date: Double, uuids: [String]) {
        self.venue = venue
        self.date = date
        self.uuids = uuids
    }

}
