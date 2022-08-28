//
//  OnTapButton.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

public struct OnTapButton: View {

    var text: String?
    var image: String?
    var systemImage: String?
    var onTap: () -> Void
    var args: [CVarArg]?
    
    public init(text: String? = nil,
                image: String? = nil,
                systemImage: String? = nil,
                onTap: @escaping () -> Void,
                args: [CVarArg]? = nil) {
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
