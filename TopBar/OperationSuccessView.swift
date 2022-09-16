import SwiftUI
import GTCloudKit

struct OperationSuccessView: View {
    
    var body: some View {
        HStack {
            Text("cloud_kit_update_success")
                .font(.caption)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(.green)
                .aspectRatio(contentMode: ContentMode.fit)
                .frame(width: 12, height: 12)
        }
    }
}
