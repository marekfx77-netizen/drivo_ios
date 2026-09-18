import SwiftUI

struct SplashView: View {
    @EnvironmentObject var state: AppState
    @State private var logoScale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @State private var btnOpacity: Double = 0

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "1a1235"), DrivoTheme.bg],
                center: .init(x: 0.5, y: 0.35),
                startRadius: 0, endRadius: 400
            ).ignoresSafeArea()

            VStack(spacing: 14) {
                Spacer()

                ZStack {
                    LinearGradient(
                        colors: [DrivoTheme.accent, Color(hex: "5B8DEF")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    Image(systemName: "steeringwheel")
                        .font(.system(size: 46))
                        .foregroundColor(.white)
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: DrivoTheme.accent.opacity(0.55), radius: 32, y: 16)
                .scaleEffect(logoScale)
                .opacity(opacity)

                Text("Drivo")
                    .font(.system(size: 52, weight: .heavy))
                    .foregroundColor(.white)
                    .opacity(opacity)

                Text("Jedz. Gdziekolwiek.")
                    .font(.system(size: 17))
                    .foregroundColor(DrivoTheme.muted)
                    .opacity(opacity)

                Spacer()

                Button {
                    withAnimation { state.screen = .home }
                } label: {
                    Text("Rozpocznij")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [DrivoTheme.accent, Color(hex: "5B8DEF")],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: DrivoTheme.accent.opacity(0.4), radius: 20, y: 8)
                }
                .padding(.horizontal, 32)
                .opacity(btnOpacity)

                Text("Kontynuujac akceptujesz Regulamin i Polityke Prywatnosci")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.3))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .opacity(btnOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                logoScale = 1; opacity = 1
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.45)) {
                btnOpacity = 1
            }
        }
    }
}
