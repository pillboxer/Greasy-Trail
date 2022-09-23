import SwiftUI

struct FetchingLogsView: View {
    var body: some View {
        HStack {
            Text("Fetching logs. Please wait")
            ProgressView()
                .scaleEffect(0.4)
        }
    }
}
