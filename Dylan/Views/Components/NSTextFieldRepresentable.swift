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
    
    func makeNSView(context: Context) -> NoCursorTextField {
        let view = NoCursorTextField()
        view.delegate = context.coordinator
        return view
    }
    
    func makeCoordinator() -> NSTextFieldCoordinator {
        NSTextFieldCoordinator(textField: self)
    }
    
    func updateNSView(_ nsView: NoCursorTextField, context: Context) {
        customize(nsView)
        nsView.stringValue = text.wrappedValue
    }
    
    func customize(_ textField: NSTextField) {
        textField.placeholderString = NSLocalizedString(placeholder, comment: "")
        textField.drawsBackground = false
        textField.isBezeled = false
        textField.focusRingType = .none
        
    }
    
}

class NoCursorTextField: NSTextField {
    
    override func currentEditor() -> NSText? {
        guard let editor = super.currentEditor() as? NSTextView else {
            return nil
        }
        editor.insertionPointColor = .clear
        return editor
    }
}

class NSTextFieldCoordinator: NSObject, NSTextFieldDelegate {
    
    var textField: NSTextFieldRepresentable
    
    init(textField: NSTextFieldRepresentable) {
        self.textField = textField
    }

    
    func controlTextDidChange(_ obj: Notification) {
        textField.text.wrappedValue = (obj.object as? NSTextField)?.stringValue ?? ""
    }
    
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        print(#function)
        return true
    }
    
    func controlTextDidBeginEditing(_ obj: Notification) {
        print(#function)
    }
    
}
