//
//  SideBarListMainRowView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 21/07/2022.
//

import SwiftUI

struct SideBarListMainRowView: View {

    let recordType: DylanRecordType
    let selection: String
    @Binding var isCollapsed: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            if recordType == .performance {
                OnTapButton(systemImage: "arrowtriangle.right.fill") {
                    withAnimation {
                        isCollapsed.toggle()
                    }
                }
                .rotationEffect(isCollapsed ? .zero : .degrees(90))
                .buttonStyle(.plain)
            }
            Text(selection.capitalized + "s")
                .font(.headline)
            Spacer()
            //            if isFetching {
            //                VStack {
            //                    ProgressView("", value: progress, total: 1)
            //                        .frame(maxWidth: 50)
            //                    Spacer()
            //                }
            //            } else {
            OnTapButton(systemImage: "cross.fill") {
                onTap()
            }
            .buttonStyle(.plain)
        }
    }

}

struct SideBarListSubView: View {
    
    let year: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(year)
            OnTapButton(systemImage: "arrow.down.circle") {
                print("Fetch")
            }
        }
    }
}
