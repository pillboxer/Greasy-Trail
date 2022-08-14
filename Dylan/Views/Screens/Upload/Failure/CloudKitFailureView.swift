//
//  UploadFailureView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import SwiftUI
import UI
import GTCloudKit

struct CloudKitFailureView: View {

    @EnvironmentObject private var cloudKitManager: CloudKitManager
    let error: String

    var body: some View {
        
        Text(String(format: NSLocalizedString("cloud_kit_failed", comment: ""), String(describing: error)))
            .padding()
        OnTapButton(text: "generic_ok") {
            Task {
                cloudKitManager.setCurrentStep(to: nil)
            }
        }
    }
}
