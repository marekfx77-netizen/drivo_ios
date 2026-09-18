import SwiftUI

public struct DialerKeyButton: View {
    public let digit: String
    public let letters: String
    public let action: () -> Void
    
    @State private var isPressed: Bool = false
    
    public init(digit: String, letters: String, action: @escaping () -> Void) {
        self.digit = digit
        self.letters = letters
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                // Tło przycisku ze szkła matowego
                Circle()
                    .fill(isPressed ? Color.white.opacity(0.22) : Color.white.opacity(0.06))
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(isPressed ? 0.35 : 0.12),
                                        Color.white.opacity(isPressed ? 0.1 : 0.03)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                
                VStack(spacing: -1) {
                    Text(digit)
                        .font(.system(size: 34, weight: .light, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    if !letters.isEmpty {
                        Text(letters)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .tracking(2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
            .frame(width: 78, height: 78)
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(KeypadButtonStyle(isPressed: $isPressed))
    }
}

// Custom button style aby precyzyjnie reagować na dotyk bez opóźnień
private struct KeypadButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}
