//
//  Store.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 19/08/2022.
//

import Combine
import SwiftUI
// swiftlint: disable force_cast
public final class Store<Value, Action> {
    
    let reducer: Reducer<Value, Action, Any>
    @Published private var value: Value
    private let environment: Any
    private var viewCancellable: AnyCancellable?
    private var effectCancellables: [UUID: AnyCancellable] = [:]
    
    public init<Environment>(
        initialValue: Value,
        reducer: Reducer<Value, Action, Environment>,
        environment: Environment
    ) {
        self.reducer = .init { value, action, environment in
            reducer(&value, action, environment as! Environment)
        }
        self.value = initialValue
        self.environment = environment
    }

    func send(_ action: Action) {
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
                                               action toGlobalAction: ((LocalAction) -> Action)?)
    -> Store<LocalState, LocalAction> {
        let localValue = toLocalValue(self.value)
        let localStore = Store<LocalState, LocalAction>(initialValue: localValue,
                                                        reducer: .init { localValue, localAction, _ in
            if let action = toGlobalAction?(localAction) {
                self.send(action)
            }
            localValue = toLocalValue(self.value)
            return []
        }, environment: self.environment)
        localStore.viewCancellable = self.$value.sink { [weak localStore] myValue in
            localStore?.value = toLocalValue(myValue)
        }
        return localStore
    }
}

@dynamicMemberLookup
public final class ViewStore<Value, Action>: ObservableObject {
    
    fileprivate var cancellable: AnyCancellable?
    @Published public fileprivate(set) var value: Value
    public let send: (Action) -> Void
    
    public init(initialValue: Value, send: @escaping (Action) -> Void) {
        self.value = initialValue
        self.send = send
    }
    
    public subscript<LocalValue>(dynamicMember keyPath: KeyPath<Value, LocalValue>) -> LocalValue {
        self.value[keyPath: keyPath]
    }
    
    public func binding<LocalValue>(get: (Value) -> LocalValue,
                                    send action: Action) -> Binding<LocalValue> {
        let localValue = get(value)
        return Binding(get: { localValue },
                       set: { _ in  self.send(action) }
        )
    }
    
    public func binding<LocalValue>(
        get: @escaping (Value) -> LocalValue,
        send toAction: @escaping (LocalValue) -> Action?
    ) -> Binding<LocalValue> {
        Binding(
            get: { get(self.value) },
            set: { value in
                guard let action = toAction(value) else {
                    return
                }
                self.send(action)
                
            }
        )
    }

}

extension Store where Value: Equatable {
    
    public var view: ViewStore<Value, Action> {
        view(removeDuplicates: ==)
    }
}

extension Store {
    public func view(
        removeDuplicates predicate: @escaping (Value, Value) -> Bool) -> ViewStore<Value, Action> {
            let viewStore = ViewStore(initialValue: value,
                                      send: send)
            viewStore.cancellable = self.$value
                .removeDuplicates(by: predicate)
                .sink { [weak viewStore] newValue in
                    viewStore?.value = newValue
                }
            return viewStore
        }
}
