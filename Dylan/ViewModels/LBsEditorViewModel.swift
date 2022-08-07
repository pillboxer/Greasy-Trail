//
//  LBsEditorViewModek.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import Foundation
import Model

class LBsEditorViewModel: EditorViewModel {
    
    enum LBEditingViewModelError: LocalizedError {
        case missingPrefix(String)
        case notANumber
        
        var errorDescription: String? {
            switch self {
            case .missingPrefix(let string):
                return String(formatted: "lb_editing_error_prefix", args: string)
            case .notANumber:
                return String(formatted: "lb_editing_error_nan")
            }
        }
    }
    
    private let sPerformance: sPerformance
    
    init(sPerformance: sPerformance) {
        self.sPerformance = sPerformance
        super.init(editable: sPerformance)
    }
    
    var lbNumbers: String {
        sPerformance.lbNumbers?.compactMap { "LB-\(String($0))"}.joined(separator: "\n") ?? ""
    }
    
    func saveLBs(_ lbs: String) {
        if lbs.isEmpty {
            edit(.lbNumbers, on: .performance, to: [])
        } else {
            let separated = lbs.components(separatedBy: .newlines)
            let withoutPrefix = separated.filter { $0.prefix(3) != "LB-" }
            Task { () -> Void in
                if let withoutPrefix = withoutPrefix.first {
                    return await setError(to: LBEditingViewModelError.missingPrefix(withoutPrefix))
                }
                let noPrefix = separated.compactMap { $0.replacingOccurrences(of: "LB-", with: "") }
                let ints = noPrefix.compactMap { Int($0) }
                guard ints.count == separated.count else {
                    return await setError(to: LBEditingViewModelError.notANumber)
                }
                edit(.lbNumbers, on: .performance, to: ints)
            }
        }
    }
    
}
