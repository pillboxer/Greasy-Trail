//
//  EditorViewModel.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 30/07/2022.
//

import Combine
import CloudKit
import Foundation

class EditorViewModel: ObservableObject {
    
    @Published private(set) var isEditing = false
    @Published private(set) var alertText: String?
    private let cloudKitManager = CloudKitManager()
    private let model: Model

    init(model: Model) {
        self.model = model
    }
    
}

extension EditorViewModel {
    
    func startEditing() {
        isEditing = true
    }
    
    func stopEditing() {
        alertText = nil
        isEditing = false
    }
        
    // swiftlint: disable force_cast
    func edit(_ field: DylanRecordField, on record: DylanRecordType, to newValue: Any) {
        Task {
            let result = await cloudKitManager.edit(field, on: record, with: model.uuid, to: newValue as! CKRecordValue)
            switch result {
            case .success:
                await delay(0.5)
                await cloudKitManager.start()
                await setAlert(to: NSLocalizedString("edit_alert_success", comment: ""))
            case .failure(let error):
                await setAlert(to: String(format: NSLocalizedString("edit_alert_failure", comment: ""),
                                   arguments: [String(describing: error)]))
            }
        }
    }
    
}

private extension EditorViewModel {
    
    @MainActor
    func setAlert(to string: String) {
        alertText = string
    }
    
}
