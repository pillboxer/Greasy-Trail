import Foundation

@propertyWrapper public struct UserDefaultsBacked<Value: Equatable>: Equatable {
    
    private let key: String
    private let storage: UserDefaults
    private let defaultValue: Value

    public var wrappedValue: Value {
        get {
            (storage.value(forKey: key) as? Value) ?? defaultValue
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
    
    public init(wrappedValue defaultValue: Value,
                key: String,
                storage: UserDefaults = .standard) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}

public extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
    
    init(key: String, storage: UserDefaults = .standard) {
        self.init(wrappedValue: nil, key: key, storage: storage)
    }
    
}
