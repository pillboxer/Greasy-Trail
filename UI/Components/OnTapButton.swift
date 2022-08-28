//
//  OnTapButton.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

public struct OnTapButton: View {
    
    private var text: String?
    private var image: String?
    private var systemImage: String?
    private var onTap: () -> Void
    private var args: [CVarArg]?
    private var plainButtonStyle: Bool
    
    public init(text: String? = nil,
                args: [CVarArg]? = nil,
                image: String? = nil,
                systemImage: String? = nil,
                plainButtonStyle: Bool = true,
                onTap: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.systemImage = systemImage
        self.onTap = onTap
        self.args = args
        self.plainButtonStyle = plainButtonStyle
    }
    
    public var body: some View {
        Button {
            onTap()
        } label: {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
            } else if let image = image {
                Image(image)
            } else if let text = text {
                Text(String(format: NSLocalizedString(text, comment: ""), arguments: args ?? []))
            }
        }
        .onHover { hover in
            hover ? NSCursor.pointingHand.push() : NSCursor.pop()
        }
        .if(plainButtonStyle) { $0.buttonStyle(.plain) }
    }
    
}
