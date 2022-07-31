//
//  View+Extensions.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK", buttonAction: (() -> Void)? = nil) -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            OnTapButton(text: buttonTitle) {
                if let buttonAction = buttonAction {
                    buttonAction()
                } else {
                    error.wrappedValue = nil
                }
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    
    var errorDescription: String? {
        String(formatted: underlyingError.errorDescription ?? "")
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
