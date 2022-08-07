//
//  EditorViewModel.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 30/07/2022.
//

import Combine
import CloudKit
import Foundation
import Model

class EditorViewModel: ObservableObject {
    
    @Published private(set) var isEditing = false
    @Published private(set) var isProcessing = false

    @Published var alertText: String?
    @Published var error: Error?
    private let cloudKitManager = CloudKitManager()
    private let editable: Editable

    init(editable: Editable) {
        self.editable = editable
    }
    
    // swiftlint: disable force_cast
    func edit(_ field: DylanRecordField, on record: DylanRecordType, to newValue: Any) {
        Task {
            await setProcessing(to: true)
            let result = await cloudKitManager.edit(field,
                                                    on: record,
                                                    with: editable.uuid,
                                                    to: newValue as! CKRecordValue)
            switch result {
            case .success:
                await delay(0.5)
                await cloudKitManager.start()
                await setAlert(to: NSLocalizedString("edit_alert_success", comment: ""))
            case .failure(let error):
                await setError(to: error)
            }
        }
    }
    
}

extension EditorViewModel {
    
    func startEditing() {
        isEditing = true
    }
    
    func stopEditing() {
        Task {
            await setProcessing(to: false)
        }
        isProcessing = false
        error = nil
        alertText = nil
        isEditing = false
    }
    
}

@MainActor
extension EditorViewModel {
    
    func setProcessing(to bool: Bool) {
        isProcessing = bool
    }
    
    func setAlert(to string: String) {
        alertText = string
    }
    
    func setError(to error: Error) {
        self.error = error
    }
    
}
