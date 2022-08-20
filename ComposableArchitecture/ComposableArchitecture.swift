//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 04/08/2022.
//

import Combine
import CloudKit
public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public func combine<Value, Action>(_ reducers: Reducer<Value, Action>...) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducers.flatMap { $0(&value, action) }
        return effects
    }
}

/// Transforms a reducer on local state to one on global state
public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>) -> Reducer<GlobalValue, GlobalAction> {
        return { globalValue, globalAction in
            guard let localAction = globalAction[keyPath: action] else {
                return []
            }
            let localEffects = reducer(&globalValue[keyPath: value], localAction)
            return localEffects.map { localEffect in
                localEffect.map { localAction -> GlobalAction in
                    var globalAction = globalAction
                    globalAction[keyPath: action] = localAction
                    return globalAction
                }.eraseToEffect()
            }
        }
    }

public func logging<Value, Action>(_ reducer:
                                   @escaping Reducer<Value, Action>) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducer(&value, action)
        let newValue = value
        return [.fireAndForget {
            print("Action: \(action)")
            print("Value: ")
            dump(newValue)
            print("-----")
        }] + effects
    }
}
