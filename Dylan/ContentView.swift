//
//  ContentView.swift
//  Dylan
//
//  Created by Henry Cooper on 24/06/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var detective = Detective()
    var body: some View {
        Text("Hello, world!")
            .padding()
            .task {
                await detective.search(song: "Like A Rolling Stone")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
