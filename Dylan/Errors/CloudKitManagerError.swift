//
//  CloudKitManagerError.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import Foundation

enum CloudKitManagerError: LocalizedError {
   
    case query(code: Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .query(let code):
            return String(formatted: "cloud_kit_query_error_\(code)")
        case .unknown:
            return String(formatted: "cloud_kit_upload_unknown")
        }
    }
   
}
