//
//  NSDatePickerRepresentable.swift
//  UI
//
//  Created by Henry Cooper on 06/09/2022.
//

import Foundation
import SwiftUI

public struct NSDatePickerRepresentable: NSViewRepresentable {

    var date: Binding<Date>
    
    public init(date: Binding<Date>) {
        self.date = date
    }
    
    public func makeNSView(context: Context) -> NSDatePicker {
        let picker = NSDatePicker()
        picker.focusRingType = .none
        picker.wantsLayer = true
        picker.font = .labelFont(ofSize: 11)
        picker.layer?.borderColor = NSColor.lightGray.cgColor
        picker.layer?.borderWidth = 0.8
        picker.datePickerStyle = .textField
        picker.datePickerElements = .yearMonthDay
        picker.layer?.cornerRadius = 4.0
        picker.action = #selector(Coordinator.onValueChange(_:))
        picker.target = context.coordinator
        return picker
    }

    public func updateNSView(_ picker: NSDatePicker, context: Context) {
        picker.dateValue = date.wrappedValue
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(owner: self)
    }

    public class Coordinator: NSObject {
        private let owner: NSDatePickerRepresentable
        init(owner: NSDatePickerRepresentable) {
            self.owner = owner
        }

        @objc func onValueChange(_ sender: Any?) {
            if let picker = sender as? NSDatePicker {
                owner.date.wrappedValue = picker.dateValue
            }
        }
    }
}
