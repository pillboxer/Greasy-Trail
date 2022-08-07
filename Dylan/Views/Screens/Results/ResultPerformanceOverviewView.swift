//
//  ResultPerformanceOverviewView.swift
//  Dylan
//
//  Created by Henry Cooper on 08/07/2022.
//

import SwiftUI
import Model

struct ResultPerformanceOverviewView: View {
        
    let model: PerformanceDisplayModel
    @ObservedObject var editorViewModel: EditorViewModel
    @State private var presentAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "house")

                Spacer()
                if editorViewModel.isEditing {
                    EditingView(text: model.venue) {
                        editorViewModel.stopEditing()
                    } onConfirm: { text in
                        editorViewModel.edit(.venue, on: .performance, to: text)
                    }
                } else {
                    Text(model.venue)
                        .font(.headline)
                        .onTapGesture(count: 3) { editorViewModel.startEditing() }
                }
                if let url = model.officialURL() {
                    OnTapButton(systemImage: "globe") {
                        NSWorkspace.shared.open(url)
                    }
                    .buttonStyle(.link)
                }
                Spacer()
            }
            Text(model.date)
            Spacer()
            HStack {
                SongsListView(songs: model.songs) { title in
//                    model.search(.init(title: title, type: .song))
                }
//                AlbumsListView(albums: searchViewModel.performanceModel?.albums ?? [],
//                               showingAppearances: true) { title in
//                    searchViewModel.search(.init(title: title, type: .album))
//                }
                if let lbNumbers = model.lbNumbers, !lbNumbers.isEmpty {
                    LBsListView(lbs: lbNumbers) { url in
                        NSWorkspace.shared.open(url)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .onChange(of: editorViewModel.alertText) { newValue in
            presentAlert = newValue != nil
        }
        .alert(editorViewModel.alertText ?? "", isPresented: $presentAlert) {
            OnTapButton(text: "Ok") {
                editorViewModel.stopEditing()
//                searchViewModel.search(.init(title: model.date, type: .performance))
            }
        }
        .errorAlert(error: $editorViewModel.error) {
            editorViewModel.stopEditing()
        }
    }

}

struct EditingView: View {
    
    @State private var text: String
    @State private var disabled = false
    let onCancel: () -> Void
    let onConfirm: (String) -> Void
    
    init(text: String, onCancel: @escaping () -> Void, onConfirm: @escaping (String) -> Void) {
        self.text = text
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        HStack {
            OnTapButton(text: "❌") {
                onCancel()
            }
            TextField("", text: $text)
            OnTapButton(systemImage: "icloud.and.arrow.up") {
                disabled = true
                onConfirm(text)
            }

        }
        .disabled(disabled)
    }
    
}
