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
            ProgressView()
            Text(LocalizedStringKey(viewModel.text))
        }
        .padding()
    }
    
}

private struct CloudKitFetchStepViewModel {
    
    let step: CloudKitManager.CloudKitFetchStep
    
    var text: String {
        switch step {
        case .fetching(let title):
            let localized = NSLocalizedString("cloud_kit_fetch_songs_progress_description", comment: "")
            return String(format: localized, arguments: [title])
        case .songs(let title):
            let localized = NSLocalizedString("cloud_kit_progress_description", comment: "")
            return String(format: localized, arguments: [title])
        case .albums(let title):
            let localized = NSLocalizedString("cloud_kit_progress_description", comment: "")
            return String(format: localized, arguments: [title])
        case .performances(let title):
            let localized = NSLocalizedString("cloud_kit_progress_description", comment: "")
            return String(format: localized, arguments: [title])
        }
    }
    
}
