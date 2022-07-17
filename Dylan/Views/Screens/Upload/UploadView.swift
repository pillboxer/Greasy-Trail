//
//  AddingView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import SwiftUI

struct UploadView: View {
    
    @EnvironmentObject private var cloudKitManager: CloudKitManager
    let recordType: DylanRecordType
    
    var body: some View {
        
        switch recordType {
        case .album:
            Text("NOT IMPLEMENTED")
        case .song:
            Text("NOT IMPLEMENTED")
        case .performance:
            PerformanceAddingView { model in
                    Task {
                        await cloudKitManager.upload(model)
                    }
                }
                .padding(.horizontal)
        }
    }
}
