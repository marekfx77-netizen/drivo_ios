import SwiftUI

public struct SoundwaveVisualizer: View {
    @ObservedObject var soundwave: SoundwaveManager
    
    public init(soundwave: SoundwaveManager) {
        self.soundwave = soundwave
    }
    
    public var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<soundwave.amplitudes.count, id: \.self) { index in
                let amplitude = soundwave.amplitudes[index]
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppTheme.neonPurple,
                                AppTheme.neonBlue,
                                AppTheme.callGreen
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 4.5, height: max(6, amplitude * 36))
                    .shadow(color: AppTheme.neonPurple.opacity(0.4), radius: 4, x: 0, y: 0)
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.05))
                .overlay(Capsule().stroke(Color.white.opacity(0.08), lineWidth: 1))
        )
    }
}
