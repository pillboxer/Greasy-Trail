//
//  OnTapButton.swift
//  Dylan
//
//  Created by Henry Cooper on 01/07/2022.
//

import SwiftUI

struct OnTapButton: View {
   
    let text: String
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(text)
        }
    }
    
}
