import SwiftUI
import UI

struct ListSongView: View {
    
    let index: Int
    let title: String
    let author: String
    let onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(index + 1).")
            ListRowView(headline: title, subheadline: author, onTap: {
                onTap()
            })
        }
    }
}
