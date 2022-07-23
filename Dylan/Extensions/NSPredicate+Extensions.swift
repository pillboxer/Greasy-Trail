//
//  NSPredicate+Extensions.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//

import Foundation

extension NSPredicate {
    
    static var misspellings: NSPredicate {
        NSPredicate(format: "name == 'misspellings'")
    }
    
}
