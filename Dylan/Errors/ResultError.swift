//
//  ResultError.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import Foundation

enum ResultError: LocalizedError {
    
case `get`(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .get(let error):
            return String(formatted: "result_error_get", args: String(describing: error))
        }
    }
    
}
