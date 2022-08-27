//
//  Model.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import Foundation

public protocol Model {
    var uuid: String { get }
}

public struct AnyModel {
    
    public var value: Model?
    
    public init<T: Model>(_ model: T) {
        self.value = model
    }
    
}

extension AnyModel: Equatable {
    
    public static func == (lhs: AnyModel, rhs: AnyModel) -> Bool {
        lhs.value?.uuid == rhs.value?.uuid
    }

}
