//
//  UploadFailureView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import SwiftUI

struct UploadFailureView: View {

    @EnvironmentObject private var cloudKitManager: CloudKitManager
    let error: String

    var body: some View {
        Text("Failed: \(error)")
        OnTapButton(text: "OK") {
            Task {
                cloudKitManager.setCurrentStep(to: nil)
            }
        }
    }
}
