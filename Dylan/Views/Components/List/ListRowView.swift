//
//  ListRowView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 13/07/2022.
//

import SwiftUI

private struct _ListRowView<V: View>: View {

    let headline: String
    var subHeadline: String?
    var withDisclosure = true

    let onTap: () -> Void
    var popoverContent: (() -> V)?
    @State private var isPopover = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(headline).font(.headline)
                if withDisclosure {
                    Spacer()
                    OnTapButton(systemImage: "chevron.forward.square.fill") {
                        onTap()
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            }
            if let subHeadline = subHeadline {
                Text(subHeadline).font(.subheadline)
            }
        }
        .popover(isPresented: $isPopover, content: {
            popoverContent?()
                .onDisappear(perform: {
                    
                    isPopover = false
                })
        })
        .contextMenu {
            OnTapButton(text: "Add LB Numbers") {
                isPopover = true
            }
        }
    }
}

struct ListRowView: View {
    
    let headline: String
    var subHeadline: String?
    let onTap: () -> Void
    
    var body: some View {
        _ListRowView<EmptyView>(headline: headline, subHeadline: subHeadline, onTap: onTap)
    }
    
}

struct PopoverRowView<V: View>: View {
    
    let headline: String
    var subHeadline: String?
    let onTap: () -> Void
    var popoverContent: (() -> V)
    var uuid: String?
    @State private var isExpanded = false
    
    var body: some View {
        _ListRowView(headline: headline,
                     subHeadline: subHeadline,
                     withDisclosure: false,
                     onTap: onTap,
                     popoverContent: popoverContent)
            
    }
    
}
