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
                switch viewStore.selectedRecordToAdd {
                case .songs:
                    AddSongView()
                case .performances:
                    AddPerformanceView()
                case .albums:
                    AddSongView()
                }
            }
            .environmentObject(viewStore)
        }
    }
}
