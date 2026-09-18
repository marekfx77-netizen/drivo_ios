import SwiftUI

// MARK: - App Theme (Dark Premium / iOS Native)
// Kolorystyka wzorowana na luksusowych interfejsach Uber Black / Drivo / Bolt Premium
public enum AppTheme {
    // Primary Backgrounds
    public static let bgDeep = Color(hex: 0x0A0A0F)         // Głęboka czerń kosmiczna
    public static let bgSurface = Color(hex: 0x12121C)      // Podstawa paneli i kart
    public static let bgElevated = Color(hex: 0x1A1A28)     // Wyniesione elementy
    public static let bgGlass = Color.white.opacity(0.06)   // Półprzezroczyste szkło

    // Accent Colors
    public static let neonPurple = Color(hex: 0x7C5CFC)     // Główny fioletowy neon
    public static let neonBlue = Color(hex: 0x4F75FF)       // Uzupełniający elektryczny błękit
    public static let callGreen = Color(hex: 0x00D68F)      // Świeża zieleń połączenia (połysk)
    public static let callGreenGlow = Color(hex: 0x00FFAB)  // Rozbłysk zieleni
    public static let endCallRed = Color(hex: 0xFF3B30)     // Czerwień zakończenia rozmowy
    public static let warningYellow = Color(hex: 0xFFB800)  // Akcent ostrzegawczy

    // Text & Monochromes
    public static let textPrimary = Color.white
    public static let textSecondary = Color(hex: 0x8E8E9F)
    public static let textTertiary = Color(hex: 0x5C5C70)
    public static let borderGlass = Color.white.opacity(0.12)
    public static let borderGlow = Color(hex: 0x7C5CFC).opacity(0.4)

    // Gradients
    public static let primaryGradient = LinearGradient(
        colors: [neonPurple, neonBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let callGradient = LinearGradient(
        colors: [Color(hex: 0x00D68F), Color(hex: 0x00B074)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let endCallGradient = LinearGradient(
        colors: [Color(hex: 0xFF453A), Color(hex: 0xD70015)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let avatarRingGradient = AngularGradient(
        gradient: Gradient(colors: [neonPurple, neonBlue, callGreen, neonPurple]),
        center: .center
    )
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}
