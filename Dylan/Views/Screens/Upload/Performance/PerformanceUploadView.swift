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
                let individualSongs = songs.components(separatedBy: .newlines).compactMap { $0.trimmingCharacters(in:.whitespacesAndNewlines) }
                let detective = Detective()
                var uuids: [String] = []
                
                
                guard !(venue.isEmpty || date.isEmpty || songs.isEmpty) else {
                    return error = .missingField
                }
                
                guard let date = formatter.date(from: date) else {
                    return error = .invalidDate(date)
                }
                
                for song in individualSongs {
                    guard let uuid = detective.uuid(for: song) else {
                        return error = .songNotRecognized(song)
                    }
                    uuids.append(uuid)
                }
                
                let model = PerformanceUploadModel(venue: venue, date: date, uuids: uuids)
                completion(model)
            }
            
        }
        
    }
    
}
