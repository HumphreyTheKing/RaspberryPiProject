//
//  ContentView.swift
//  UNLV PARKIFY
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                VStack {
                    Image("High-Resolution-Color-Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 500)
                    
// Add a visual loader below the text
            ProgressView() // This creates a spinning loader
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5) // Adjust size of the loader
                .padding(.top, 20)
                }
                .onAppear {
                    // Set a delay before switching to the main view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        isLoading = false
                    }
                }
            } else {
                MainView() // Switch to the main view after loading
            }
        }
    }
}

#Preview {
    ContentView()
}
