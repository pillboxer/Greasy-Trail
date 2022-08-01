//
//  EditingView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 01/08/2022.
//

import SwiftUI

struct EditingView: View {
    
    let model: Editable
    
    var body: some View {
        if let model = model as? sPerformance {
            PerformanceEditingView(model: PerformanceEditorViewModel(sPerformance: model))
        }
    }
    
}
