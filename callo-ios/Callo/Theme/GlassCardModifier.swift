import SwiftUI

// MARK: - Glass Card Modifier
public struct GlassCardModifier: ViewModifier {
    public var cornerRadius: CGFloat = 20
    public var borderOpacity: Double = 0.12
    public var blurRadius: CGFloat = 16

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Color.white.opacity(0.04))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(borderOpacity * 1.5),
                                Color.white.opacity(borderOpacity * 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Neon Glow Modifier
public struct NeonGlowModifier: ViewModifier {
    public var color: Color
    public var radius: CGFloat = 12
    public var opacity: Double = 0.45

    public func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(opacity), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(opacity * 0.5), radius: radius * 2, x: 0, y: 0)
    }
}

// MARK: - View Extensions
public extension View {
    func glassCard(cornerRadius: CGFloat = 20, borderOpacity: Double = 0.12) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius, borderOpacity: borderOpacity))
    }

    func neonGlow(color: Color, radius: CGFloat = 12, opacity: Double = 0.45) -> some View {
        modifier(NeonGlowModifier(color: color, radius: radius, opacity: opacity))
    }
}
