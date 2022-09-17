import SwiftUI
import ComposableArchitecture

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
                        AddSongView()
                    }
                default:
                    EmptyView()
                }
            }
            .environmentObject(viewStore)
        }
    }
}
