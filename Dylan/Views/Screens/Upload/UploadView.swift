//
//  AddingView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import SwiftUI

struct UploadView: View {

    let recordType: DylanRecordType

    let onTap: (PerformanceUploadModel) -> Void

    var body: some View {

        switch recordType {
        case .album:
            Text("NOT IMPLEMENTED")
        case .song:
            Text("NOT IMPLEMENTED")
        case .performance:
            PerformanceAddingView { model in
                  onTap(model)
                }
                .padding(.horizontal)
        }
    }
}
