//
//  ContentView.swift
//  Parkify
//
//  Created by Ayyan Malik on 10/17/24.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreMotion
import UserNotifications

//this is to check how fast app user is moving
//to check if driving or not
//uses coreMotion library package
//creating class for driveMode ability
class DriveModeViewModel: ObservableObject {
    private let motionDetector = CMMotionActivityManager()
    
    //boolean to set actual if driving or not
    @Published var isDriving = false // Indicates whether driving is detected
    
    //if app detects too much motion, may mean user is driving
    func startMonitoring() {
        if CMMotionActivityManager.isActivityAvailable() {
            motionDetector.startActivityUpdates(to: OperationQueue.main) { [weak self] activity in
                guard let self = self else { return }
                //if true, app shouldn't be available, should pop up with a notification
                //to confirm if user is driving or not
                if let activity = activity, activity.automotive {
                    DispatchQueue.main.async {
                        self.isDriving = true
                    }
                } else {
                    //if false, user is fine to use app
                    DispatchQueue.main.async {
                        self.isDriving = false // Unblock functionality
                    }
                }
            }
        }
    }
    
    //notification function - one option, "Im not driving"
    //based on apple's native im not driving notification
    private func sendMotionNotification() {
        let _ = UNNotificationAction(
            identifier: "NOT_ACTUALLY_DRIVING",
            title: "I'm Not Driving",
            options: [.foreground]
        )
    }
    
    //function that actuallly sends notificaiton
    private func sendDriveModeNotification() {
        //made unmutable to make sure you cant skip it
        let content = UNMutableNotificationContent()
        content.title = "Driving Detected"
        content.body = "Driving Detected - For your safety, Parkify is only available when not driving"
        content.categoryIdentifier = "DRIVE_MODE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
       _ = UNNotificationRequest(identifier: "DRIVE_MODE_ALERT", content: content, trigger: trigger)

    }
}



struct ParkingGarage: Identifiable {
    let id = UUID()
    let title: String
    let address: String
    let status: String
    let spots: Int
    let spotsFilled: Int //adding in extra variable for more detailed view
    let coordinate: CLLocationCoordinate2D
    
    
    // Calculates percentage of spots filled for progress bar
    var percentageFilled: Double {
        return Double(spotsFilled) / Double(spots)
    }
}

class ParkingViewModel: ObservableObject {
    @Published var garages = [
        ParkingGarage(
            title: "Cottage Grove Parking Garage",
            address: "1067 Cottage Grove Ave, Las Vegas, NV 89119",
            status: "High Traffic",
            spots: 2031,
            spotsFilled: 1700,
            coordinate: CLLocationCoordinate2D(latitude: 36.1112, longitude: -115.1401)
        ),
        ParkingGarage(
            title: "Tropicana Parking Garage",
            address: "12 Wilbur St, Las Vegas, NV 89119",
            status: "High Traffic",
            spots: 1752,
            spotsFilled: 956,
            coordinate: CLLocationCoordinate2D(latitude: 36.103, longitude: -115.1431)
        ),
        ParkingGarage(
            title: "University Gateway Parking Garage",
            address: "1280 Dorothy Ave, Las Vegas, NV 89119",
            status: "Low Traffic",
            spots: 534,
            spotsFilled: 255,
            coordinate: CLLocationCoordinate2D(latitude: 36.10342, longitude: -115.136193)
        )
    ]
}

struct ContentView: View {

    @StateObject var viewModel = ParkingViewModel()
    //necessary for triggering loading screen at app open
    @State private var isLoading = true

    
    var body: some View {
        ZStack {
            //if statement triggers loading
            if isLoading {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    VStack {
                        //pulls up with logo image for a few seconds,
                        //then switches to main app
                        Image("logo.png") //loading screen for app!
                                           .resizable()
                                           .scaledToFit()
                                           .frame(width: 300, height: 300)
                                           .foregroundColor(.gray)
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding()
          
                    }
                }
            } else {
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
        }
        .onAppear {
            //3 second delay for loading, gives time for map to load
            //and for app to check if user is driving via motion detection
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //not only does this line turn off the loading screen
                //it fixes a bug where the map image was stuck to constantly
                //loading
                isLoading = false
            }
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
                    //changed text showing to include a fraction
                    //instead of just how many spots are avail
                    Text("\(garage.spotsFilled)/\(garage.spots) filled")
                }
                .font(.subheadline)
            // creating VStack element for progress bar
              VStack(alignment: .leading) {
                  Text("Usage: \(Int(garage.percentageFilled * 100))%")
                      .font(.subheadline)
                      .padding(.bottom, 4)
                  
                  //actual code for progress bar
                  ProgressView(value: garage.percentageFilled)
                      .progressViewStyle(LinearProgressViewStyle())
                      .tint(colorForPercentage(garage.percentageFilled))
              }
              .padding(.top, 8)
                
                
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
    
    
    //function to change text color for percent full
    //helps visually show differences to students
    private func colorForPercentage(_ percentage: Double) -> Color {
        switch percentage {
        case 0..<0.5:
            return .green // Between 0 and 50 = green
        case 0.5..<0.8: // 50 - 80 = yellow
            return .yellow
        default: //anything above 80 is red
            return .red
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

