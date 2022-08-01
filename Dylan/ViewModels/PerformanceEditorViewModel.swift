//
//  LBsEditorViewModek.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import Foundation

final class PerformanceEditorViewModel: RecordEditorViewModel {
    
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
    
    func validateLBs(_ lbs: String) async -> [Int]? {
        if lbs.isEmpty {
            return []
        } else {
            let separated = lbs.components(separatedBy: .newlines)
            let withoutPrefix = separated.filter { $0.prefix(3) != "LB-" }
            if let withoutPrefix = withoutPrefix.first {
                await setError(to: LBEditingViewModelError.missingPrefix(withoutPrefix))
                return nil
            }
            let noPrefix = separated.compactMap { $0.replacingOccurrences(of: "LB-", with: "") }
            let ints = noPrefix.compactMap { Int($0) }
            guard ints.count == separated.count else {
                await setError(to: LBEditingViewModelError.notANumber)
                return nil
            }
            return ints
        }
    }
    
}
