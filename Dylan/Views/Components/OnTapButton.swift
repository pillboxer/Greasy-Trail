//
//  OnTapButton.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

struct OnTapButton: View {

    var text: String?
    var image: String?
    var systemImage: String?
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
            } else if let image = image {
                Image(image)
            } else if let text = text {
                Text(text)
            }
        }
    }

}
