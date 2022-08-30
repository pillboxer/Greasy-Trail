//
//  Add+View.swift
//  Add
//
//  Created by Henry Cooper on 04/09/2022.
//

import SwiftUI
import ComposableArchitecture

public struct AddView: View {
    
    let store: Store<AddState, AddAction>
    @ObservedObject var viewStore: ViewStore<AddState, AddAction>
    
    public init(store: Store<AddState, AddAction>) {
        self.store = store
        self.viewStore = store.view
    }
    
    public var body: some View {
        Group {
            switch viewStore.selectedRecordToAdd {
            case .song:
                AddSongView()
            case .performance:
                AddPerformanceView()
            case .album:
                AddSongView()
            default:
                fatalError()
            }
        }
        .environmentObject(viewStore)
        .transaction { transaction in
            transaction.animation = nil
        }
    }
}
