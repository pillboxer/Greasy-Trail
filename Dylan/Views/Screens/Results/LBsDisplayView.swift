//
//  LBsDisplayView.swift
//  Dylan
//
//  Created by Henry Cooper on 09/07/2022.
//

import SwiftUI

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
        let number = NSNumber(integerLiteral: lbNumber)
        let formatted = formatter.string(from: number)!
        return "LB-\(formatted)"
    }
    
    func url() -> URL {
        let url = URL(string: "http://losslessbob.wonderingwhattochoose.com/detail/\(lbURLString()).html")!
        return url
    }
    
}

struct LBsDisplayView: View {
    
    @Binding var model: PerformanceDisplayModel?
    @Binding var currentViewType: ResultView.ResultViewType
    @State private var selection: String?
    private var models: [LBDisplayModel]?
    
    init(model: Binding<PerformanceDisplayModel?>, currentViewType: Binding<ResultView.ResultViewType>) {
        self._model = model
        self._currentViewType = currentViewType
        if let lbs = model.wrappedValue?.lbNumbers {
            models = lbs.map { LBDisplayModel(lbNumber: $0) }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .onTapGesture {
                        currentViewType = .performanceOverview
                    }
                Spacer()
                Text(model?.venue ?? "")
                Spacer()
            }
            Table(models ?? [], selection: $selection) {
                TableColumn("LBNumbers") { model in
                    Text(model.description)
                        .gesture(TapGesture(count: 2).onEnded {
                            NSWorkspace.shared.open(model.url())
                        })
                        .simultaneousGesture(TapGesture()
                            .onEnded {
                                self.selection = model.id
                            })
                }
            }
        }
        .padding()
    }
}
