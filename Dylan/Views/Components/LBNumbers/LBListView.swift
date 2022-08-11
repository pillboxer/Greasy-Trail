//
//  LBListView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 13/07/2022.
//

import SwiftUI
import UI

private struct LBDisplayModel: Identifiable {

    private let uuid = UUID().uuidString
    let lbNumber: Int

    var id: String {
        uuid + String(lbNumber)
    }

    var description: String {
        "LB - \(String(lbNumber))"
    }

    private func lbURLString() -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 5
        formatter.maximumIntegerDigits = 5
        let number = NSNumber(value: lbNumber)
        let formatted = formatter.string(from: number)!
        return "LB-\(formatted)"
    }

    func url() -> URL {
        let url = URL(string: "http://losslessbob.wonderingwhattochoose.com/detail/\(lbURLString()).html")!
        return url
    }

}

struct LBsListView: View {

    let lbs: [Int]
    let onTap: (URL) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("lbs_list_title").font(.title)
                .padding(.bottom)
            ScrollView {
                ForEach(lbs, id: \.self) { lbNumber in
                    let model = LBDisplayModel(lbNumber: lbNumber)
                    HStack(alignment: .top) {
                        ListRowView(headline: model.description) {
                            onTap(model.url())
                        }
                    }
                    .padding(2)
                }
            }
        }
    }
}
