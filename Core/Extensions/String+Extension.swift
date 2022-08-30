//
//  String+Extension.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import Foundation

public extension String {
    static let invalid = "INVALID UUID"

    init(formatted: String, args: CVarArg...) {
        self.init(format: NSLocalizedString(formatted, comment: ""), args)
    }
    
}
