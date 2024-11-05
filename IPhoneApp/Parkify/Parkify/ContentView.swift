//
//  ContentView.swift
//  Parkify
//
//  Created by Ayyan Malik on 10/17/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ParkingGarage: Identifiable {
    let id = UUID()
    let title: String
    let address: String
    let status: String
    let spots: Int
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @StateObject private var viewModel = ParkingViewMode()

    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                HStack {
                    Text("Parkify")
                    .font(.title2)
                    .forebackgroundColor(.white)
                    .padding(.leading)
                Spacer()
            }
            .frame(height: 50)
            .background(Color.red.opacity(0.9))

            
            }
        }
    }
}

#Preview {
    ContentView()
}
