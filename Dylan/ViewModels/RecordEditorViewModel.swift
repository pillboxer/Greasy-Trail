//
//  EditorViewModel.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 30/07/2022.
//

import Combine
import CloudKit
import Foundation

class RecordEditorViewModel: ObservableObject {
    
    @Published private(set) var isEditing = false
    @Published private(set) var isProcessing = false

    @Published var alertText: String?
    @Published var error: Error?
    private let cloudKitManager = CloudKitManager()
    let editable: Editable

    init(editable: Editable) {
        self.editable = editable
    }
    
    func edit(_ field: DylanRecordField, on record: DylanRecordType, to newValue: Any) {
        edit([field], on: record, to: [newValue])
    }
    
    func edit(_ fields: [DylanRecordField], on record: DylanRecordType, to newValues: [Any]) {
        Task {
            await setProcessing(to: true)
            let result = await cloudKitManager.edit(fields,
                                                    on: record,
                                                    with: editable.uuid,
                                                    to: newValues.compactMap { $0 as? CKRecordValue })
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

extension RecordEditorViewModel {
    
    func startEditing() {
        isEditing = true
    }
    
    func stopEditing() {
        error = nil
        alertText = nil
        isEditing = false
    }
    
}

@MainActor
extension RecordEditorViewModel {
    
    func setProcessing(to bool: Bool) {
        isProcessing = bool
    }
    
    func setAlert(to string: String) {
        setProcessing(to: false)
        alertText = string
    }
    
    func setError(to error: Error) {
        setProcessing(to: false)
        self.error = error
    }
    
}
