//
//  NSTextFieldRepresentable.swift
//  Dylan
//
//  Created by Henry Cooper on 27/06/2022.
//

import Foundation
import SwiftUI

public struct NSTextFieldRepresentable: NSViewRepresentable {

    let placeholder: String
    var text: Binding<String>
    let textColor: NSColor?
    let font: NSFont?
    var onCommit: (() -> Void)?
    
    public init(placeholder: String,
                text: Binding<String>,
                textColor: NSColor? = nil,
                font: NSFont? = nil,
                onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.text = text
        self.textColor = textColor
        self.onCommit = onCommit
        self.font = font
    }

    public func makeNSView(context: Context) -> NSTextField {
        let view = NSTextField()
        view.delegate = context.coordinator
        return view
    }

    public func makeCoordinator() -> NSTextFieldCoordinator {
        NSTextFieldCoordinator(textField: self)
    }

    public func updateNSView(_ nsView: NSTextField, context: Context) {
        customize(nsView)
        nsView.stringValue = text.wrappedValue
    }

    private func customize(_ textField: NSTextField) {
        textField.placeholderString = NSLocalizedString(placeholder, comment: "")
        textField.focusRingType = .none
        textField.wantsLayer = true
        textField.maximumNumberOfLines = 1
        textField.layer?.borderColor = NSColor.lightGray.cgColor
        textField.layer?.borderWidth = 0.8
        textField.textColor = textColor ?? .labelColor
        if let font = font {
            textField.font = font
            textField.frame.size.height = font.pointSize * 1.4
        }
        textField.layer?.cornerRadius = 4.0
    }

}
public class NSTextFieldCoordinator: NSObject, NSTextFieldDelegate {

    var textField: NSTextFieldRepresentable

    init(textField: NSTextFieldRepresentable) {
        self.textField = textField
    }

    public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            textField.onCommit?()
            textField.text.wrappedValue = ""
            return true
        }
        return false
    }

    public func controlTextDidChange(_ obj: Notification) {
        textField.text.wrappedValue = (obj.object as? NSTextField)?.stringValue ?? ""
    }
}
