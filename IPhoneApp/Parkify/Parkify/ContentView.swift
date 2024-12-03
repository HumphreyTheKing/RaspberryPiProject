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

class ParkingViewModel: ObservableObject {
    @Published var garages = [
        ParkingGarage(
            title: "Cottage Grove Parking Garage",
            address: "1067 Cottage Grove Ave, Las Vegas, NV 89119",
            status: "High Traffic",
            spots: 540,
            coordinate: CLLocationCoordinate2D(latitude: 36.1112, longitude: -115.1401)
        ),
        ParkingGarage(
            title: "Tropicana Parking Garage",
            address: "12 Wilbur St, Las Vegas, NV 89119",
            status: "High Traffic",
            spots: 960,
            coordinate: CLLocationCoordinate2D(latitude: 36.103, longitude: -115.1431)
        ),
        ParkingGarage(
            title: "University Gateway Parking Garage",
            address: "1280 Dorothy Ave, Las Vegas, NV 89119",
            status: "Low Traffic",
            spots: 1023,
            coordinate: CLLocationCoordinate2D(latitude: 36.10342, longitude: -115.136193)
        )
    ]
}

struct ContentView: View {
    @StateObject private var viewModel = ParkingViewModel()
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header matching React's red header
                HStack {
                    Text("Parkify")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.red.opacity(0.9))
                
                // Main content area
                if UIDevice.current.userInterfaceIdiom == .pad {
                    // iPad layout (side by side like desktop React)
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            // Map section
                            mapSection
                                .frame(width: geometry.size.width * 0.67)
                            
                            // Cards section
                            ScrollView {
                                garageCards
                            }
                            .frame(width: geometry.size.width * 0.33)
                            .background(Color(.systemBackground))
                        }
                    }
                } else {
                    // iPhone layout (stacked like mobile React)
                    ScrollView {
                        VStack(spacing: 0) {
                            // Map section
                            mapSection
                                .frame(height: 500)
                            
                            // Cards section
                            garageCards
                                .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // Map section view
    private var mapSection: some View {
        ZStack {
            MapView(garages: viewModel.garages)
                .cornerRadius(8)
                .shadow(radius: 2)
                .padding()
            
            if isLoading {
                Color(.systemBackground).opacity(0.8)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
    }
    
    // Garage cards section
    private var garageCards: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.garages) { garage in
                GarageCard(garage: garage)
            }
        }
    }
}

struct GarageCard: View {
    let garage: ParkingGarage
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Card Header
            VStack(alignment: .leading, spacing: 4) {
                Text(garage.title)
                    .font(.headline)
                    .padding(.bottom, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Card Content
            VStack(alignment: .leading, spacing: 8) {
                Text(garage.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .italic()
                
                HStack {
                    Text("Status:")
                        .fontWeight(.medium)
                    Spacer()
                    Text(garage.status)
                        .foregroundColor(garage.status == "High Traffic" ? .red : .green)
                }
                .font(.subheadline)
                
                HStack {
                    Text("Parking Spots:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(garage.spots)")
                }
                .font(.subheadline)
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: isHovered ? 4 : 1)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    let garages: [ParkingGarage]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Match React map center and zoom
        let initialCoordinate = CLLocationCoordinate2D(
            latitude: 36.1077863,
            longitude: -115.1453609
        )
        let region = MKCoordinateRegion(
            center: initialCoordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: false)
        
        // Add markers
        for garage in garages {
            let annotation = MKPointAnnotation()
            annotation.title = garage.title
            annotation.coordinate = garage.coordinate
            mapView.addAnnotation(annotation)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // Customize marker appearance
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Marker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
