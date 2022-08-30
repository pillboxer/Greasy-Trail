//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 04/08/2022.
//

import Combine
import CloudKit
import CasePaths

public struct Reducer<Value, Action, Environment> {
    let reducer: (inout Value, Action, Environment) -> [Effect<Action>]
    
    public init(reducer: @escaping (inout Value, Action, Environment) -> [Effect<Action>]) {
        self.reducer = reducer
    }
}

extension Reducer {
    func callAsFunction(_ value: inout Value, _ action: Action, _ environment: Environment) -> [Effect<Action>] {
        self.reducer(&value, action, environment)
    }
}

extension Reducer {
    public static func combine(_ reducers: Reducer...) -> Reducer {
        .init { value, action, environment in
            let effects = reducers.flatMap { $0(&value, action, environment) }
            return effects
        }
    }
}

extension Reducer {
    /// Transforms a reducer on local state to one on global state
    public func pullback<GlobalValue, GlobalAction, GlobalEnvironment>(
        value: WritableKeyPath<GlobalValue, Value>,
        action: CasePath<GlobalAction, Action>,
        environment: @escaping (GlobalEnvironment) -> Environment
    )-> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
        
        return .init { globalValue, globalAction, globalEnvironment in
            
            guard let localAction = action.extract(from: globalAction) else {  return [] }
            let localEffects = self(&globalValue[keyPath: value], localAction, environment(globalEnvironment))
            
            return localEffects.map { localEffect in
                localEffect.map(action.embed)
                    .eraseToEffect()
            }
        }
    }
}

public extension Reducer {
    func logging(printer: @escaping (Environment) -> (String) -> Void = { _ in { print($0) }}) -> Reducer {
        return .init { value, action, environment in
            let effects = reducer(&value, action, environment)
            let newValue = value
            let print = printer(environment)
            return [.fireAndForget {
                print("Action: \(action)")
                print("Value: ")
                var dumped = ""
                dump(newValue, to: &dumped)
                print(dumped)
                print("-----")
            }] + effects
        }
    }
}
