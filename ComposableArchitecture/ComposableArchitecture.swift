//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 04/08/2022.
//

import Combine
// swiftlint: disable identifier_name
public final class Store<State, Action>: ObservableObject {
    
    let reducer: (inout State, Action) -> Void
    @Published public var value: State
    private var cancellable: AnyCancellable?
    
    public init(initialValue: State, reducing: @escaping (inout State, Action) -> Void) {
        self.reducer = reducing
        self.value = initialValue
    }
    
    public func send(_ action: Action) {
        print("*** Sending Action ***")
        reducer(&value, action)
    }

    public func view<LocalState, LocalAction>(value toLocalValue: @escaping (State) -> LocalState,
                                              action toGlobalAction:  @escaping (LocalAction) -> Action)
    -> Store<LocalState, LocalAction> {
        let localValue = toLocalValue(self.value)
        let localStore = Store<LocalState, LocalAction>(initialValue: localValue) { localValue, localAction in
            print("*** In LocalStore closure ***")
            // Local store has a new reducer
            // Send parent store the action
            self.send(toGlobalAction(localAction))
            print("*** Get current local value (after change) ***")
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
        for (index, reducer) in reducers.enumerated() {
            print("*** Calling reducer \(index + 1) ***")
            reducer(&value, action)
        }
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>) -> (inout GlobalValue, GlobalAction) -> Void {
        return { globalValue, globalAction in
            print("*** Calling Pullback ***")
            guard let localAction = globalAction[keyPath: action] else {
                print("*** Action doesn't belong to this reducer ***")
                return
            }
            reducer(&globalValue[keyPath: value], localAction)
        }
    }
