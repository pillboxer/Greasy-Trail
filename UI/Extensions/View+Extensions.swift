//
//  View+Extensions.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import SwiftUI

public extension View {
    @MainActor
    func errorAlert(error: Binding<Error?>, title: String = "Error", action: (() -> Void)? = nil) -> some View {
        let alertError = AlertError(error: error.wrappedValue)
        return alert(String(describing: error), isPresented: .constant(alertError != nil)) {
            OnTapButton(text: "OK") {
                if let action = action {
                    action()
                } else {
                    error.wrappedValue = nil
                }
            }
        } message: {
            Text(alertError?.recoverySuggestion ?? "")
        }
    }
    
    func alert(string: Binding<String?>, title: String = "", action: (() -> Void)? = nil) -> some View {
        return alert(title, isPresented: .constant(string.wrappedValue != nil)) {
            OnTapButton(text: "OK") {
                if let action = action {
                    action()
                } else {
                    string.wrappedValue = nil
                }
            }
        } message: {
            Text(string.wrappedValue ?? "")
        }

    }
}

struct AlertError {
    let underlyingError: Error
    
    var errorDescription: String? {
        (underlyingError as? LocalizedError)?.localizedDescription ?? String(describing: underlyingError)
    }
    
    var recoverySuggestion: String? {
        (underlyingError as? LocalizedError)?.recoverySuggestion ?? ""
    }
    
    init?(error: Error?) {
        guard let error = error else {
            return nil
        }
        underlyingError = error
    }
}
