import SwiftUI
import GTCloudKit
import Core

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
                Text(tr("cloud_kit_fetching_in_progress", args: type.rawValue.capitalized))
                Spacer()
                ProgressView(value: progress)
                    .frame(width: 256)
                Text(String(Int(progress * 100)) + "%")
                    .frame(width: 36)
            }
        }
    }
}
