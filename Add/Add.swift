import SwiftUI
import ComposableArchitecture
import Core
import os

public let logger = Logger(subsystem: .subsystem, category: "Performance editing")

public struct AddView: View {
    
    let store: Store<AddState, AddAction>
    
    public init(store: Store<AddState, AddAction>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                switch viewStore.displayedView {
                case .add(let work):
                    switch work {
                    case .songs:
                        AddSongView()
                    case .performances:
                        AddPerformanceView()
                    case .albums:
                        AddAlbumsView()
                    }
                default:
                    EmptyView()
                }
            }
            .environmentObject(viewStore)
        }
    }
}
