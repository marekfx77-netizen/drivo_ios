import Foundation
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentStreet: String = "Lokalizowanie..."
    @Published var currentCity: String = "Polska"
    @Published var fullAddress: String = "Pobieranie adresu GPS..."
    @Published var isFirstLocationReceived: Bool = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 5 // Update every 5 meters
        manager.activityType = .automotiveNavigation
        authorizationStatus = manager.authorizationStatus
        requestPermission()
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // Fallback coordinate in Warsaw center if denied
            if userLocation == nil {
                self.userLocation = CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122)
                self.currentStreet = "Plac Defilad 1"
                self.currentCity = "Warszawa"
                self.fullAddress = "Plac Defilad 1, Warszawa"
            }
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        
        DispatchQueue.main.async {
            self.userLocation = latest.coordinate
            if !self.isFirstLocationReceived {
                self.isFirstLocationReceived = true
            }
        }

        // Reverse geocode to get actual street name and city
        geocoder.reverseGeocodeLocation(latest) { [weak self] placemarks, error in
            guard let self = self, error == nil, let place = placemarks?.first else { return }
            
            DispatchQueue.main.async {
                let street = place.thoroughfare ?? place.name ?? "Twoja ulica"
                let number = place.subThoroughfare ?? ""
                let city = place.locality ?? place.administrativeArea ?? "Polska"
                
                let streetWithNumber = number.isEmpty ? street : "\(street) \(number)"
                self.currentStreet = streetWithNumber
                self.currentCity = city
                self.fullAddress = "\(streetWithNumber), \(city)"
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError: \(error.localizedDescription)")
    }
}
