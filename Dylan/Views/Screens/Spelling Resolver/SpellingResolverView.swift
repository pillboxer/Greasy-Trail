//
//  SpellingResolverView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//

import SwiftUI
import UI

struct SpellingResolverView: View {
    
    @ObservedObject var manager: SpellingResolverManager
    @State private var selection = DylanRecordType.song
    @State private var result: Bool?
    @State private var isUploading = false
    @FocusState private var keyIsFocused: Bool
    
    var body: some View {
        VStack {
            TextField("Key", text: $manager.key)
                .focused($keyIsFocused)
            TextField("Value", text: $manager.value)
            HStack {
                Picker(selection: $selection, label: Text("Type")) {
                    Text("Song").tag(DylanRecordType.song)
                }
                .fixedSize()
                Spacer()
                if let result = result {
                    OnTapButton(text: result ? "✅" : "❌") {
                        isUploading = false
                        keyIsFocused = true
                        self.result = nil
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                OnTapButton(systemImage: "icloud.and.arrow.up") {
                    Task {
                        isUploading = true
                        result = await manager.save(key: manager.key, value: manager.value, type: selection)
                    }
                }
                .disabled(manager.key.isEmpty || manager.value.isEmpty || isUploading)
                .buttonStyle(.plain)
            }
        }
        .errorAlert(error: $manager.error)
        .padding()
    }
    
}
