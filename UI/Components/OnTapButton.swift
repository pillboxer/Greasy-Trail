//
//  OnTapButton.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

public enum ButtonStyle {
    case plain
    case link
    case regular
}

public struct OnTapButton: View {
    
    private var text: String?
    private var image: String?
    private var systemImage: String?
    private var onTap: () -> Void
    private var args: [CVarArg]?
    
    public init(text: String? = nil,
                args: [CVarArg]? = nil,
                image: String? = nil,
                systemImage: String? = nil,
                onTap: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.systemImage = systemImage
        self.onTap = onTap
        self.args = args
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
    }
    
}

public struct PlainOnTapButton: View {
    
    private var text: String?
    private var image: String?
    private var systemImage: String?
    private var onTap: () -> Void
    private var args: [CVarArg]?
    
    public init(text: String? = nil,
                args: [CVarArg]? = nil,
                image: String? = nil,
                systemImage: String? = nil,
                onTap: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.systemImage = systemImage
        self.onTap = onTap
        self.args = args
    }
    
    public var body: some View {
        OnTapButton(text: text,
                    args: args,
                    image: image,
                    systemImage: systemImage,
                    onTap: onTap)
            .buttonStyle(.plain)
    }
    
}
