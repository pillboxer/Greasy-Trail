//
//  Store.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 19/08/2022.
//

import Combine

public final class Store<State, Action>: ObservableObject {
    
    let reducer: Reducer<State, Action>
    @Published public private(set) var value: State
    private var viewCancellable: AnyCancellable?
    private var effectCancellables: Set<AnyCancellable> = []
    
    public init(initialValue: State, reducing: @escaping Reducer<State, Action>) {
        self.reducer = reducing
        self.value = initialValue
    }
    
    public func send(_ action: Action) {
        let effects = reducer(&value, action)
        effects.forEach { effect in
            var cancellable: AnyCancellable?
            var didComplete = false
            cancellable = effect.sink(receiveCompletion: { [weak self] _ in
                didComplete = true
                if let cancellable = cancellable {
                    self?.effectCancellables.remove(cancellable)}
            }, receiveValue: self.send)
            if didComplete, let cancellable = cancellable {
                self.effectCancellables.insert(cancellable)
            }
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
        localStore.viewCancellable = self.$value.sink { [weak localStore] myValue in
            localStore?.value = toLocalValue(myValue)
        }
        return localStore
    }
}
