//
//  LBAddingView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 31/07/2022.
//

import SwiftUI
import UI

struct LBAddingView: View {
    
    @ObservedObject var editorViewModel: LBsEditorViewModel
    
    @State private var lbNumbers: String = ""
    @State private var presetAlert = false
    init(editorViewModel: LBsEditorViewModel) {
        lbNumbers = editorViewModel.lbNumbers
        self.editorViewModel = editorViewModel
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $lbNumbers)
            OnTapButton(text: "Save") {
                editorViewModel.saveLBs(lbNumbers)
            }
        }
        .padding()
        .errorAlert(error: $editorViewModel.error)
        .alert(string: $editorViewModel.alertText, title: "Success") {
            editorViewModel.stopEditing()
        }
        .disabled(editorViewModel.isProcessing)
    }
}
