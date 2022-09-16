import SwiftUI

struct UploadingView: View {
    
    let progress: Double
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "icloud.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 12, height: 12)
                Text("cloud_kit_uploading_in_progress")
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
