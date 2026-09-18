import SwiftUI
import MapKit

// MARK: - Navigation
enum AppScreen {
    case splash, home, search, ride, tracking, history, profile
}

// MARK: - Application State
final class AppState: ObservableObject {
    @Published var screen: AppScreen = .splash
    @Published var selectedTab: Int = 0
    
    // Map & Location
    @Published var mapMode: String = "classic" // "classic" | "satellite" | "hybrid"
    @Published var mapType: MKMapType = .standard
    @Published var pickupName: String = "Plac Defilad 1"
    @Published var pickupAddress: String = "Plac Defilad 1, Warszawa"
    @Published var destinationName: String = "Złote Tarasy"
    @Published var destinationAddress: String = "ul. Złota 59, Warszawa"
    @Published var tripDistanceKm: Double = 2.1
    @Published var tripDurationMinutes: Int = 8
    
    // Ride selection
    @Published var selectedRide: String = "eco"
    
    // Promo / Discount
    @Published var promoCode: String = ""
    @Published var discountPercent: Double = 0.0 // 0.25 = 25%
    @Published var promoError: String? = nil
    @Published var promoSuccess: Bool = false
    
    // Payment
    @Published var paymentMethod: String = "Apple Pay"
    
    // Saved addresses
    @Published var homeAddress: String = "ul. Marszałkowska 84, Warszawa"
    @Published var workAddress: String = "Rondo Daszyńskiego 1, Warszawa"
    
    // Notifications Settings
    @Published var notifRideStatus: Bool = true
    @Published var notifPromos: Bool = true
    @Published var notifSounds: Bool = true
    
    // Helper method to apply promo code
    func applyPromo(code: String) -> Bool {
        let clean = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if clean == "DRIVO25" || clean == "START25" {
            promoCode = clean
            discountPercent = 0.25
            promoSuccess = true
            promoError = nil
            HapticsManager.shared.notification(.success)
            return true
        } else if clean == "VIP" || clean == "VIP50" {
            promoCode = clean
            discountPercent = 0.50
            promoSuccess = true
            promoError = nil
            HapticsManager.shared.notification(.success)
            return true
        } else {
            promoError = "Nieprawidłowy kod promocyjny"
            promoSuccess = false
            HapticsManager.shared.notification(.error)
            return false
        }
    }
}

// MARK: - Root View
struct ContentView: View {
    @StateObject var state = AppState()
    @StateObject var locationManager = LocationManager.shared

    var body: some View {
        ZStack {
            DrivoTheme.bg.ignoresSafeArea()
            
            switch state.screen {
            case .splash:
                SplashView()
                    .environmentObject(state)
            case .home:
                HomeView()
                    .environmentObject(state)
            case .search:
                SearchView()
                    .environmentObject(state)
            case .ride:
                RideSelectView()
                    .environmentObject(state)
            case .tracking:
                TrackingView()
                    .environmentObject(state)
            case .history:
                HistoryView()
                    .environmentObject(state)
            case .profile:
                ProfileView()
                    .environmentObject(state)
            }
        }
        .animation(.easeInOut(duration: 0.28), value: state.screen)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - App Theme
struct DrivoTheme {
    static let bg        = Color(hex: "09090E")
    static let surface   = Color(hex: "13131D")
    static let card      = Color(hex: "181826")
    static let card2     = Color(hex: "212133")
    static let cardLight = Color(hex: "2B2B42")
    static let accent    = Color(hex: "7C5CFC")
    static let accent2   = Color(hex: "9D82FF")
    static let gradientA = Color(hex: "7C5CFC")
    static let gradientB = Color(hex: "4F75FF")
    static let green     = Color(hex: "00D68F")
    static let red       = Color(hex: "FF4757")
    static let amber     = Color(hex: "FFB020")
    static let muted     = Color.white.opacity(0.55)
    static let border    = Color.white.opacity(0.09)
    static let borderLight = Color.white.opacity(0.18)
    static let pill      = Color.white.opacity(0.06)
}
