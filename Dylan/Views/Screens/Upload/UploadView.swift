//
//  AddingView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import SwiftUI
import GTCloudKit
import Model

struct UploadView: View {

    let recordType: DylanRecordType

    let onTap: (PerformanceUploadModel) -> Void

    var body: some View {

        switch recordType {
        case .performance:
            PerformanceAddingView { model in
                  onTap(model)
                }
                .padding(.horizontal)
        default:
            Text("NOT IMPLEMENTED")
        }
    }
}
