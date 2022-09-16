import SwiftUI
import ComposableArchitecture
import GTCloudKit
import UI
import Core

struct DownloadFailedView: View {
    
    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?
    
    private let error: GTError
    @ObservedObject private var viewStore: ViewStore<TopBarState, TopBarViewAction>
    
    init(viewStore: ViewStore<TopBarState, TopBarViewAction>, error: GTError) {
        self.viewStore = viewStore
        self.error = error
    }
    
    var body: some View {
        HStack {
            Text(viewStore.state.showingCloudKitError ?
                 String(describing: error) : String(formatted: "cloud_kit_fetch_error"))
            .font(.caption)
            Spacer()
            PlainOnTapButton(systemImage: "arrow.clockwise.circle.fill") {
                viewStore.send(.refetch(lastFetchDate))
            }
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.green)
            PlainOnTapButton(systemImage: "exclamationmark.triangle.fill") {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([.string], owner: nil)
                pasteboard.setString(String(describing: error), forType: .string)
                viewStore.send(.toggleCloudKitError)
            }
            .symbolRenderingMode(.palette)
            .foregroundStyle(.black, .black, .yellow)
            .aspectRatio(contentMode: ContentMode.fit)
            .frame(width: 12, height: 12)
        }
    }    
}
