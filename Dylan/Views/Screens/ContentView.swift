//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    private let formatter = Formatter()

    @State var songModel: SongDisplayModel?
    var body: some View {
        Group {
            if let songModel = songModel {
                ResultView(model: songModel)
                    .environmentObject(formatter)
            }
            else {
                SearchView(model: $songModel)
            }
        }
        .frame(width: 600, height: 400)

    }
}
