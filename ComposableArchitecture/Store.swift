//
//  Store.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 19/08/2022.
//

import Combine
// swiftlint: disable force_cast
public final class Store<Value, Action>: ObservableObject {
    
    let reducer: Reducer<Value, Action, Any>
    @Published public private(set) var value: Value
    private let environment: Any
    private var viewCancellable: AnyCancellable?
    private var effectCancellables: [UUID: AnyCancellable] = [:]
    
    public init<Environment>(
        initialValue: Value,
        reducer: @escaping Reducer<Value, Action, Environment>,
        environment: Environment
    ) {
        self.reducer = { value, action, environment in
            reducer(&value, action, environment as! Environment)
        }
        self.value = initialValue
        self.environment = environment
    }
    public func send(_ action: Action) {
        let effects = reducer(&value, action, self.environment)
        effects.forEach { effect in
            var didComplete = false
            let uuid = UUID()
            let effectCancellable = effect.sink(
                receiveCompletion: { [weak self] _ in
                    didComplete = true
                    self?.effectCancellables[uuid] = nil
                },
                receiveValue: { [weak self] in self?.send($0) }
            )
            if !didComplete {
                self.effectCancellables[uuid] = effectCancellable
            }
        }
    }
    
    public func scope<LocalState, LocalAction>(value toLocalValue: @escaping (Value) -> LocalState,
                                               action toGlobalAction:  @escaping (LocalAction) -> Action)
    -> Store<LocalState, LocalAction> {
        let localValue = toLocalValue(self.value)
        let localStore = Store<LocalState, LocalAction>(initialValue: localValue,
                                                        reducer: { localValue, localAction, _ in
            self.send(toGlobalAction(localAction))
            localValue = toLocalValue(self.value)
            return []
        }, environment: self.environment)
        localStore.viewCancellable = self.$value.sink { [weak localStore] myValue in
            localStore?.value = toLocalValue(myValue)
        }
        return localStore
    }
}
