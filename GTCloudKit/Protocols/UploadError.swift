//
//  UploadError.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import Foundation

public enum UploadError: Error {
    case songNotRecognized(String)
    case missingField
    case invalidDate(String)
}
