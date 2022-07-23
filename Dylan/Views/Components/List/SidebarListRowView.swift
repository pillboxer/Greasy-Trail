//
//  ListRowView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 12/07/2022.
//

import SwiftUI

struct SidebarListRowView: View {

    let recordType: DylanRecordType
    let isFetching: Bool
    var progress: Double?

    @State var selection: String
    @Binding var nextSearch: Search?
    @Binding var selectedID: String?

    let onTap: () -> Void

    var body: some View {
        NavigationLink(destination: destinationFor(selection), tag: selection, selection: $selectedID) {
            HStack {
                Text(selection.capitalized + "s")
                    .font(.headline)
                Spacer()
                if isFetching {
                    VStack {
                        ProgressView("", value: progress, total: 1)
                            .frame(maxWidth: 50)
                        Spacer()
                    }
                } else {
                    OnTapButton(systemImage: "cross.fill") {
                        onTap()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
//        .disabled(isFetching)
    }

    @ViewBuilder
    func destinationFor(_ selection: String) -> some View {
        if let section = DylanRecordType(rawValue: selection) {
            switch section {
            case .song:
                AllSongsView(nextSearch: $nextSearch)
            case .album:
                AllAlbumsView(nextSearch: $nextSearch)
            case .performance:
                AllPerformancesView(nextSearch: $nextSearch)
            default:
                fatalError("Should not reach here")
            }
        } else {
            fatalError()
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
