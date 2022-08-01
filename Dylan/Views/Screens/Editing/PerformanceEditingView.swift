//
//  PerformanceEditingView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 01/08/2022.
//

import SwiftUI

struct PerformanceEditingView: View {
    
    @ObservedObject var model: PerformanceEditorViewModel
    
    private let formatter = Formatter()
    
    @State private var venue: String = ""
    @State private var date: String = ""
    @State private var lbNumbers: String = ""
    @State private var songs: String = ""
    @State private var isDisabled = false
    
    private var performance: sPerformance! {
        model.editable as? sPerformance
    }
    
    var body: some View {
        VStack {
            TextField("", text: $venue)
            TextField("", text: $date)
            HStack {
                TextEditor(text: $songs)
                TextEditor(text: $lbNumbers)
            }
            HStack {
                if model.isProcessing {
                    ProgressView()
                }
                Spacer()
                OnTapButton(text: "Edit") {
                    // FIXME: Handle songs
                    guard let date = formatter.date(from: date) else {
                        fatalError()
                    }
                    Task {
                        if let lbs = await model.validateLBs(lbNumbers) {
                            model.edit([.venue, .date, .lbNumbers], on: .performance, to: [venue, date, lbs])
                            
                        }
                    }
                }
                .disabled(isDisabled)
            }
            
        }
        .padding()
        .onAppear {
            venue = performance.venue
            self.date = formatter.dateString(of: performance.date)
            lbNumbers = performance.lbNumbers?.compactMap { String("LB-\($0)") }.joined(separator: "\n") ?? ""
            self.songs = performance.songs.compactMap { $0.title }.joined(separator: "\n")
        }
        .onChange(of: model.isProcessing, perform: { newValue in
            isDisabled = newValue
        })
        .alert(string: $model.alertText) {
            model.stopEditing()
        }
        .errorAlert(error: $model.error)
    }
}
