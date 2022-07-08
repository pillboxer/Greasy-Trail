//
//  UserDefaultsBacked.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Foundation

@propertyWrapper struct UserDefaultsBacked<Value> {
    let key: String
    var storage: UserDefaults = .standard

    var wrappedValue: Value? {
        get { storage.value(forKey: key) as? Value }
        set { storage.setValue(newValue, forKey: key) }
    }
}
