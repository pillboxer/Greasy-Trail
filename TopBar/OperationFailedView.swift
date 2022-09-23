import SwiftUI
import ComposableArchitecture
import GTCloudKit
import UI
import Core

struct OperationFailedView: View {
    
    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?
    
    private let error: GTError
    @ObservedObject private var viewStore: ViewStore<TopBarState, TopBarViewAction>
    
    init(viewStore: ViewStore<TopBarState, TopBarViewAction>, error: GTError) {
        self.viewStore = viewStore
        self.error = error
    }
    
    var body: some View {
        HStack {
            PlainOnTapButton(systemImage: "xmark.circle") {
                viewStore.send(.reset)
            }
            Text(viewStore.state.showingError ?
                 String(describing: error) : tr("operation_error"))
            Spacer()
            PlainOnTapButton(systemImage: "exclamationmark.triangle.fill") {
                viewStore.send(.toggleError)
            }
            .symbolRenderingMode(.palette)
            .foregroundStyle(.black, .black, .yellow)
            .frame(width: 12, height: 12)
        }
    }    
}
