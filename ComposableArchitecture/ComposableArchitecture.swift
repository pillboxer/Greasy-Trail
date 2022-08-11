//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 04/08/2022.
//

import Combine
import CloudKit
// swiftlint: disable identifier_name
public final class Store<State, Action>: ObservableObject {
    
    let reducer: (inout State, Action) -> Void
    @Published public private(set) var value: State
    private var cancellable: AnyCancellable?
    
    public init(initialValue: State, reducing: @escaping (inout State, Action) -> Void) {
        self.reducer = reducing
        self.value = initialValue
    }
    
    public func send(_ action: Action) {
        reducer(&value, action)
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

        }
        // Local store subscribes to my value
        localStore.cancellable = self.$value.sink { [weak localStore] myValue in
            localStore?.value = toLocalValue(myValue)
        }
        return localStore
    }
    
    public func transform<LocalAction>(_ f: @escaping (LocalAction) -> Action) -> Store<State, LocalAction> {
        return Store<State, LocalAction>(initialValue: self.value) { state, localAction  in
            self.send(f(localAction))
            state = self.value
        }
    }
    
}

public func combine<Value, Action>(_ reducers: (inout Value, Action) -> Void...) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers {
            // Pullback
            reducer(&value, action)
        }
    }
}

public func logging<Value, Action>(_ reducer:
                                   @escaping (inout Value, Action) -> Void) -> (inout Value, Action) -> Void {
    return { value, action in
        // Combine reducer
        reducer(&value, action)
        print("Action: \(action)")
        print("Value: ")
        dump(value)
        print("-----")
    }
}

// tableSelectionReducer, value: \AllPerformancesState.ids, action: \AllPerformancesViewAction.tableSelect

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>)-> (inout GlobalValue, GlobalAction) -> Void {
        return { globalValue, globalAction in
            guard let localAction = globalAction[keyPath: action] else {
                return
            }
            reducer(&globalValue[keyPath: value], localAction)
        }
    }
