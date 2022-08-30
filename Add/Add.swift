//
//  Add.swift
//  Add
//
//  Created by Henry Cooper on 20/08/2022.
//

import SwiftUI
import GTCloudKit
import ComposableArchitecture

public struct AddState: Equatable {
    public var selectedRecordToAdd: DylanRecordType
    
    public init(selectedRecordToAdd: DylanRecordType) {
        self.selectedRecordToAdd = selectedRecordToAdd
    }
}

public enum AddAction: Equatable {
    case selectRecordToAdd(DylanRecordType)
}

public func addReducer(state: inout AddState,
                       action: AddAction,
                       environment: Void) -> [Effect<AddAction>] {
    switch action {
    case .selectRecordToAdd(let dylanRecordType):
        state.selectedRecordToAdd = dylanRecordType
        return []
    }
}

public struct AddView: View {
    
    let store: Store<AddState, AddAction>
    @ObservedObject var viewStore: ViewStore<AddState, AddAction>
    
    public init(store: Store<AddState, AddAction>) {
        self.store = store
        self.viewStore = store.scope(value: { $0 }, action: { $0 }).view
    }
    
    public var body: some View {
        Picker("", selection: .constant(viewStore.value.selectedRecordToAdd)) {
            ForEach(DylanRecordType.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }.pickerStyle(.segmented)
    }
    
}
