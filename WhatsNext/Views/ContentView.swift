//
//  ContentView.swift
//  WhatsNext
//
//  Created by Tristan Chay on 19/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @AppStorage("showingWelcome") var showingWelcome = true
    
    var body: some View {
        SetupView()
            .sheet(isPresented: $showingWelcome) {
                WelcomeView(showingWelcome: $showingWelcome)
            }
    }
}

#Preview {
    ContentView()
}
