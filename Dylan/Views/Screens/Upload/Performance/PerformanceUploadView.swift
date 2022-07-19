//
//  PerformanceUploadView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 17/07/2022.
//

import SwiftUI

struct PerformanceAddingView: View {
    
    private let formatter = Formatter()

    @State private var venue: String = ""
    @State private var date: String = ""
    
    @State private var songs: String = ""
    @State private var error: UploadError?
    
    let completion: (PerformanceUploadModel) -> Void
    
    var body: some View {
        
        if let error = error {
            Text("ERROR: \(String(describing: error))")
            OnTapButton(text: "OK") {
                self.error = nil
            }
        }
        else {
            TextField("Venue", text: $venue)
            TextField("Date", text: $date)
            TextEditor(text: $songs)
            
            OnTapButton(text: "Upload") {
                let trimmed = songs.trimmingCharacters(in: .newlines)
                let individualSongs = trimmed.components(separatedBy: .newlines)
                    .compactMap { $0.trimmingCharacters(in:.whitespacesAndNewlines) }
                let withCorrectApostrophe = individualSongs.compactMap { $0.replacingOccurrences(of: "’", with: "'")}
                let detective = Detective()
                var uuids: [String] = []
                
                
                guard !(venue.isEmpty || date.isEmpty || songs.isEmpty) else {
                    return error = .missingField
                }
                
                guard let date = formatter.date(from: date) else {
                    return error = .invalidDate(date)
                }
                
                for song in withCorrectApostrophe {
                    var title = song
                    if song == "—" || song == "" {
                        print("It's break")
                        title = "BREAK"
                    }
                    guard let uuid = detective.uuid(for: title) else {
                        return error = .songNotRecognized(title)
                    }
                    uuids.append(uuid)
                }
                
                let model = PerformanceUploadModel(venue: venue, date: date, uuids: uuids)
                completion(model)
                self.venue = ""
                self.date = ""
                self.songs = ""
            }
            
        }
        
    }
    
}

