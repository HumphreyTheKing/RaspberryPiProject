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

            GeometryReader { geometry in
                HStack(spacing: 0) {
                    MapView(garages: viewModel.garages)
                        .frame(
                            width: UIDevice.current.userInterfaceIdiom == .pad ?
                                geometry.size.width * 0.65 : geometry.size.width
                        )
                    if UIDevice .current.userInterfaceIdiom == .pad {
                        GarageListView(garages: viewModel.garages)
                            .frame(width: geometry.size.width * 0.35)

                    }
                }

            }
            }
            .NavigationBarHidden(true)
            
        }
    }
}

struct MapView: UIViewRepresentable {
    let garages: [ParkingGarage]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
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
    }
}

struct GarageListView: View {
    let garages: [ParkingGarage]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(garages) { garage in
                    GarageCard(garage: garage)
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
}

struct GarageCard: View {
    let garage: ParkingGarage
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(garage.title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Divider()
            
            Text(garage.address)
                .font(.subheadline)
                .italic()
                .multilineTextAlignment(.center)
            
            Text("Status: \(garage.status)")
                .font(.subheadline)
            
            Text("Parking Spots Remaining: \(garage.spots)")
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

class ParkingViewModel: ObservableObject {
    @Published var garages: [ParkingGarage] = [
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}