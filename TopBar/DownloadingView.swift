import SwiftUI
import GTCloudKit

struct DownloadingView: View {
    
    let type: DylanRecordType
    let progress: Double
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: type.bridged.imageName)
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 12, height: 12)
                Text(String(formatted: "cloud_kit_fetching_in_progress", args: type.rawValue.capitalized))
                    .font(.caption)
                Spacer()
                ProgressView(value: progress)
                    .frame(width: 256)
                Text(String(Int(progress * 100)) + "%")
                    .font(.caption)
                    .frame(width: 36)
            }
        }
    }
}
