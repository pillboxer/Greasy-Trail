//
//  ListRowView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import SwiftUI

struct SidebarListRowView: View {

    let recordType: DylanRecordType
    var progress: Double?
    @State var selection: String
    @State var isCollapsed = true
    
    var years: [String] = ["1960s", "1970s"]

    @Binding var nextSearch: Search?
    @Binding var selectedID: String?

    let onTap: () -> Void

    var body: some View {
        NavigationLink(destination: destination(), tag: selection, selection: $selectedID) {
            VStack {
                SideBarListMainRowView(recordType: recordType,
                                       selection: selection,
                                       isCollapsed: $isCollapsed,
                                       onTap: onTap)
                if recordType == .performance && !isCollapsed {
                    ForEach(years, id: \.self) { year in
                        SideBarListSubView(year: year)
                    }
                }
            }
        }
        .onChange(of: selectedID) { newValue in
            if recordType == .performance,
               newValue == recordType.rawValue {
                collapse(false)
            } else {
                collapse(true)
            }

        }
    }

    private func collapse(_ bool: Bool) {
        withAnimation {
            isCollapsed = bool
        }
    }

    @ViewBuilder
    func destination() -> some View {
        switch recordType {
        case .song:
            AllSongsView(nextSearch: $nextSearch)
        case .album:
            AllAlbumsView(nextSearch: $nextSearch)
        case .performance:
            EmptyView()
        }
    }

}

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 25.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

struct ProgressValueView: View {

    @State var progress: Double

    var body: some View {
        ProgressView(value: progress, total: 1.0)
            .progressViewStyle(GaugeProgressStyle())
            .frame(width: 10, height: 10)
            .contentShape(Rectangle())
            .onTapGesture {
                if progress < 1.0 {
                    withAnimation {
                        progress += 0.2
                    }
                }
            }
    }
}
