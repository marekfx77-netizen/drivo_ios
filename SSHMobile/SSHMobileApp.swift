import SwiftUI

@main
struct SSHMobileApp: App {
    @StateObject private var appSession = SSHAppSession()
    @AppStorage("appearanceMode") private var appearanceMode = "system"
    @AppStorage("appLanguage") private var appLanguage = "system"

    private var colorScheme: ColorScheme? {
        switch appearanceMode {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSession)
                .preferredColorScheme(colorScheme)
                .environment(\.locale, appLanguage == "system" ? Locale.current : Locale(identifier: appLanguage))
        }
    }
}
