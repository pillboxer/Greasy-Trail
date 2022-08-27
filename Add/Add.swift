//
//  Add.swift
//  Add
//
//  Created by Henry Cooper on 20/08/2022.
//

import SwiftUI
import GTCloudKit
import ComposableArchitecture

public struct AddState {
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
    
    @ObservedObject var store: Store<AddState, AddAction>
    
    public init(store: Store<AddState, AddAction>) {
        self.store = store
    }
    
    public var body: some View {
        Picker("", selection: .constant(store.value.selectedRecordToAdd)) {
            ForEach(DylanRecordType.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }.pickerStyle(.segmented)
    }
    
}
