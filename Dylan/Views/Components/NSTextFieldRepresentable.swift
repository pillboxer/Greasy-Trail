//
//  NSTextFieldRepresentable.swift
//  Dylan
//
//  Created by Henry Cooper on 27/06/2022.
//

import Foundation
import SwiftUI

struct NSTextFieldRepresentable: NSViewRepresentable {
    
    let placeholder: String
    var text: Binding<String>
    var onCommit: () -> Void
    
    func makeNSView(context: Context) -> NSTextField {
        let view = NSTextField()
        view.delegate = context.coordinator
        return view
    }
    
    func makeCoordinator() -> NSTextFieldCoordinator {
        NSTextFieldCoordinator(textField: self)
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        customize(nsView)
        nsView.stringValue = text.wrappedValue
    }
    
    func customize(_ textField: NSTextField) {
        textField.placeholderString = NSLocalizedString(placeholder, comment: "")
        textField.focusRingType = .none
        textField.wantsLayer = true
        textField.layer?.borderColor = NSColor.lightGray.cgColor
        textField.layer?.borderWidth = 0.8
        textField.layer?.cornerRadius = 4.0
        DispatchQueue.main.async {
            if let responder = textField.window?.firstResponder,
               !(responder is NSTextView) {
                textField.window?.makeFirstResponder(textField)
            }
        }
    }
    
}
class NSTextFieldCoordinator: NSObject, NSTextFieldDelegate {
    
    var textField: NSTextFieldRepresentable
    
    init(textField: NSTextFieldRepresentable) {
        self.textField = textField
    }

    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            textField.onCommit()
            return true
        }
        return false
    }
    
    func controlTextDidChange(_ obj: Notification) {
        textField.text.wrappedValue = (obj.object as? NSTextField)?.stringValue ?? ""
    }
    
}
