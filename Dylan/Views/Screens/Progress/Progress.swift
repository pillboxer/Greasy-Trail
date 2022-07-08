//
//  Progress.swift
//  Dylan
//
//  Created by Henry Cooper on 07/07/2022.
//

import SwiftUI

struct FetchProgressView: View {
    
    private let viewModel: CloudKitFetchStepViewModel
    
    init(step: CloudKitManager.CloudKitFetchStep) {
        self.viewModel = CloudKitFetchStepViewModel(step: step)
    }
    
    var body: some View {
        VStack {
            ProgressView(value: viewModel.progressValue)
            Text(LocalizedStringKey(viewModel.text))
        }
        .padding()
    }
    
}

private struct CloudKitFetchStepViewModel {
    
    let step: CloudKitManager.CloudKitFetchStep
    
    var progressValue: Double {
        Double(step.rawValue) / Double(CloudKitManager.CloudKitFetchStep.allCases.count - 1)
    }
    
    var text: String {
        switch step {
        case .songs:
            return "cloud_kit_fetch_songs_progress_description"
        case .albums:
            return "cloud_kit_fetch_albums_progress_description"
        case .performances:
            return "cloud_kit_fetch_performances_progress_description"

        }
    }
    
}
