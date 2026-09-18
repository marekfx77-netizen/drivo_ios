import SwiftUI

// MARK: - Navigation
enum AppScreen { case splash, home, search, ride, tracking, history, profile }

class AppState: ObservableObject {
    @Published var screen: AppScreen = .splash
    @Published var mapMode: String = "classic"
    @Published var selectedRide: String = "eco"
}

// MARK: - Root View
struct ContentView: View {
    @StateObject var state = AppState()
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F").ignoresSafeArea()
            switch state.screen {
            case .splash:   SplashView().environmentObject(state)
            case .home:     HomeView().environmentObject(state)
            case .search:   SearchView().environmentObject(state)
            case .ride:     RideSelectView().environmentObject(state)
            case .tracking: TrackingView().environmentObject(state)
            case .history:  HistoryView().environmentObject(state)
            case .profile:  ProfileView().environmentObject(state)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: state.screen)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Theme
struct DrivoTheme {
    static let bg      = Color(hex: "0A0A0F")
    static let surface = Color(hex: "141420")
    static let card    = Color(hex: "1C1C2E")
    static let card2   = Color(hex: "232336")
    static let accent  = Color(hex: "7C5CFC")
    static let accent2 = Color(hex: "9B7BFF")
    static let green   = Color(hex: "00D68F")
    static let red     = Color(hex: "FF4757")
    static let amber   = Color(hex: "FFB020")
    static let muted   = Color.white.opacity(0.5)
    static let border  = Color.white.opacity(0.08)
    static let pill    = Color.white.opacity(0.06)
}
