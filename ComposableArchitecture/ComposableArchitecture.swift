//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 04/08/2022.
//

import Combine
import CloudKit
// swiftlint: disable opening_brace
public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]
public typealias Effect<Action> = (@escaping (Action) -> Void) -> Void

public final class Store<State, Action>: ObservableObject {
    
    let reducer: Reducer<State, Action>
    @Published public private(set) var value: State
    private var cancellable: AnyCancellable?
    
    public init(initialValue: State, reducing: @escaping Reducer<State, Action>) {
        self.reducer = reducing
        self.value = initialValue
    }
    
    public func send(_ action: Action) {
        let effects = reducer(&value, action)
        effects.forEach { effect in
            effect(self.send)
        }
    }
    
    public func view<LocalState, LocalAction>(value toLocalValue: @escaping (State) -> LocalState,
                                              action toGlobalAction:  @escaping (LocalAction) -> Action)
    -> Store<LocalState, LocalAction> {
        let localValue = toLocalValue(self.value)
        let localStore = Store<LocalState, LocalAction>(initialValue: localValue) { localValue, localAction in
            // Local store has a new reducer
            // Send parent store the action
            self.send(toGlobalAction(localAction))
            localValue = toLocalValue(self.value)
            return []
        }
        // Local store subscribes to my value
        localStore.cancellable = self.$value.sink { [weak localStore] myValue in
            localStore?.value = toLocalValue(myValue)
        }
        return localStore
    }
    
}

public func combine<Value, Action>(_ reducers: Reducer<Value, Action>...) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducers.flatMap { $0(&value, action) }
        return effects
    }
}

public func logging<Value, Action>(_ reducer:
                                   @escaping Reducer<Value, Action>) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducer(&value, action)
        let newValue = value
        return [{ _ in
            print("Action: \(action)")
            print("Value: ")
            dump(newValue)
            print("-----")
        }] + effects
    }
}

/// Transforms a reducer on local state to one on global state
public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>) -> Reducer<GlobalValue, GlobalAction> {
        
        // Return our new reducer. We feed this in with the global state and action.
        // Then we go down and call the ultimate local reducer with our global state
        return { globalValue, globalAction in
            guard let localAction = globalAction[keyPath: action] else {
                return []
            }
            // Read the value using &globalValue[keyPath: value] and set it using &globalValue[keyPath: value]
            let localEffects = reducer(&globalValue[keyPath: value], localAction)
            return localEffects.map { localEffect in
                return { callback in
                    // () -> GlobalAction? is just a GlobalEffect
                    // localEffect() is returning an action
                    localEffect { localAction in
                        var globalAction = globalAction
                        globalAction[keyPath: action] = localAction
                        callback(globalAction)
                    }
                }
            }
        }
    }
